/*
  |      ___                  __  __
  |     / _ \ _ __ __ _  __ _|  \/  | ___  _ __
  |    | | | | '__/ _` |/ _` | |\/| |/ _ \| '_ \
  |    | |_| | | | (_| | (_| | |  | | (_) | | | |
  |     \___/|_|  \__, |\__,_|_|  |_|\___/|_| |_|
  |               |___/
  |
  |    Copyright (C) 2012 - 2021  Andreas Filsinger
  |
  |    This program is free software: you can redistribute it and/or modify
  |    it under the terms of the GNU General Public License as published by
  |    the Free Software Foundation, either version 3 of the License, or
  |    (at your option) any later version.
  |
  |    This program is distributed in the hope that it will be useful,
  |    but WITHOUT ANY WARRANTY; without even the implied warranty of
  |    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  |    GNU General Public License for more details.
  |
  |    You should have received a copy of the GNU General Public License
  |    along with this program.  If not, see <http://www.gnu.org/licenses/>.
  |
  |    http://orgamon.org/
  |
 */
package org.orgamon.orgamon;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import android.app.Service;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.SoundPool;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.BatteryManager;
import android.os.IBinder;
import android.provider.MediaStore;
import android.util.Log;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPSClient;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.util.TrustManagerUtils;

import static org.orgamon.orgamon.R.*;

public class orgaMonUploader extends Service {

    static final String TAG = "Uploader";
    static final String ALREADY_UPLOADED_PREFIX = "u";
    static final long DELETE_OLDER_THAN = 3L * 24L * 3600L * 1000L; // 3 Tage

    private Uploader uploader;
    private boolean runs = false;

    // Sound-Effekte
    static SoundPool soundPool = null;
    static int soundFail;
    static int soundOk;
    static int soundBeep;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public synchronized void onCreate() {
        super.onCreate();

        Log.d(TAG, "onCreate");
        uploader = new Uploader();
        if (soundPool==null) {
            soundPool =  new SoundPool.Builder()
                    .setMaxStreams(1)
                    .build();
            soundBeep = soundPool.load(getApplicationContext(), raw.beep48, 1);
            soundFail = soundPool.load(getApplicationContext(), raw.fail48, 1);
            soundOk = soundPool.load(getApplicationContext(), raw.ok48, 1);
        }
    }

    @Override
    public synchronized int onStartCommand(Intent intent, int flags, int startId) {

        Log.d(TAG, "onStartCommand");
        soundPool.play(soundBeep, 1, 1, 1, 0, 1f);
        if (!runs) {
            runs = true;
            uploader.start();
        }
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public synchronized void onDestroy() {
        super.onDestroy();
        Log.d(TAG, "onDestory");
        if (runs) {
            uploader.interrupt();
        }
        soundPool.play(soundFail, 1, 1, 1, 0, 1f);
    }

    class OrgaMonPicsFilter implements FileFilter {

        public boolean accept(File pathname) {
            if (pathname.isDirectory())
                return false;
            return (pathname.getName().indexOf("-") == 3);
        }
    }

    class OrgaMonOldPicsFilter implements FileFilter {

        public boolean accept(File pathname) {

            if (pathname.isDirectory())
                return false;

            if (!pathname.getName().startsWith(ALREADY_UPLOADED_PREFIX))
                return false;

            return (pathname.lastModified() + DELETE_OLDER_THAN < System
                    .currentTimeMillis());
        }
    }

    class Uploader extends Thread {

        private boolean isBatteryGood() {

            Intent batteryIntent = registerReceiver(null, new IntentFilter(
                    Intent.ACTION_BATTERY_CHANGED));
            switch (batteryIntent.getIntExtra(BatteryManager.EXTRA_STATUS, 0)) {
                case BatteryManager.BATTERY_STATUS_CHARGING:
                case BatteryManager.BATTERY_STATUS_FULL:
                    // Log.i(TAG, "Powered Battery");
                    return true;
            }

            int rawlevel = batteryIntent.getIntExtra(
                    BatteryManager.EXTRA_LEVEL, -1);
            double scale = batteryIntent.getIntExtra(
                    BatteryManager.EXTRA_SCALE, -1);
            double level = -1;
            if (rawlevel >= 0 && scale > 0) {
                level = rawlevel / scale;
                if (level < 0.5) {
                    Log.i(TAG, "Weak Battery");
                    return false;
                } else {
                    // Log.i(TAG, "Good Battery");
                }

            } else {
                Log.i(TAG, "Unsure about Battery");
            }

            // Im Zweifel für den Angeklagten
            return true;
        }

        private boolean isNetworkAvailable() {
            ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
            NetworkInfo networkInfo = cm.getActiveNetworkInfo();
            // if no network is available networkInfo will be null, otherwise
            // check if we are connected
            if (networkInfo != null && networkInfo.isConnected()) {
                return true;
            }
            return false;
        }

        private void galleryAdd(File f) {

            // add to Gallery
            Intent galleryIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
            galleryIntent.setData(Uri.fromFile(f));
            getApplicationContext().sendBroadcast(galleryIntent);
        }

        private void galleryRemove(File f) {
            // remove from Gallery
            ContentResolver resolver = getApplicationContext().getContentResolver();
            resolver.delete(
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI, MediaStore.Images.Media.DATA +
                            "=?", new String[]{f.getAbsolutePath()});

        }

        @Override
        public void run() {

            // Mark that File is NOT Valid until full upload
            final String cTMP_POSTFIX = ".$$$";

            // Sleep Durations [in Seconds] !
            final int cSLEEP_AFTER_UPLAOD_SUCCESS = 1;
            final int cSLEEP_COMMAND_CONNECTION_LOST = 10;
            final int cSLEEP_AFTER_EXCEPTION = 30;
            final int cSLEEP_AFTER_NO_WORK_AT_ALL = 45;
            final int cSLEEP_AFTER_NO_NETWORK = 60;
            final int cSLEEP_AFTER_LOW_BATTERY = 60 * 5;
            final int cSLEEP_AFTER_STORE_FAIL = 2 * 60;
            final int cSLEEP_AFTER_NO_CONNECT = 2 * 60;
            final int cSLEEP_AFTER_CONNECTION_LOST = 2 * 60;
            final int cSLEEP_AFTER_LOGIN_FAIL = 10 * 60;
            final int cSLEEP_DEFAULT = 5;

            int nextSleepLength = cSLEEP_DEFAULT;
            long remoteFSize;
            long localFSize;
            boolean useSecure = amCreateActivity.iFTPS.equals("true");

            OrgaMonPicsFilter uploadMask = new OrgaMonPicsFilter();
            OrgaMonOldPicsFilter deleteMask = new OrgaMonOldPicsFilter();

            while (runs) {

                FTPClient ftpClient = null;
                FTPSClient ftpsClient = null;
                if (useSecure) {
                    ftpsClient = new FTPSClient(false);
                    ftpsClient.setTrustManager(TrustManagerUtils.getAcceptAllTrustManager());
                    ftpClient = ftpsClient;
                } else {
                    ftpClient = new FTPClient();
                }
                ftpClient.setControlKeepAliveTimeout(2 * 60);
                ftpClient.setConnectTimeout(30 * 1000);
                ftpClient.setDefaultTimeout(60 * 1000);

                while (true) {

                    try {

                        // Check Battery
                        if (!isBatteryGood()) {
                            Log.d(TAG, "Low Battery");
                            nextSleepLength = cSLEEP_AFTER_LOW_BATTERY;
                            break;
                        }

                        // Check Network
                        if (!isNetworkAvailable()) {
                            Log.d(TAG, "No Network");
                            nextSleepLength = cSLEEP_AFTER_NO_NETWORK;
                            break;
                        }

                        // Check the File System for Workload
                        File root = new File(amCreateActivity.iFotoPath);
                        Log.i(TAG, "ls "+root.getAbsolutePath()+"/???-*");

                        File[] files = root.listFiles(uploadMask);
                        if (files == null) {
                            Log.i(TAG, "Workpath invalid");
                            nextSleepLength = cSLEEP_AFTER_EXCEPTION;
                            break;
                        }

                        // Path not valid
                        if (files.length == 0) {
                            Log.i(TAG, "No Workload");
                            nextSleepLength = cSLEEP_AFTER_NO_WORK_AT_ALL;
                            break;
                        }

                        // Make local & remote Filenames
                        String lFile = root.getAbsolutePath() + File.separator
                                + files[0].getName();
                        String rFile = files[0].getName();
                        localFSize = files[0].length();

                        if (localFSize < 1024) {
                            // Seems to be a tiny Picture Fragment
                            if (!files[0].delete()) {
                                // Panic!!
                                Log.e(TAG, "Panic: can not delete " + lFile);
                                runs = false;
                            }
                            nextSleepLength = cSLEEP_AFTER_UPLAOD_SUCCESS;
                            break;
                        }

                        Log.i(TAG, "do job '" + lFile + "'");

                        try {

                            // Fall Back to the Web-Host
                            if (amCreateActivity.iHost_FTP.length()==0) {
                                amCreateActivity.iHost_FTP = amCreateActivity.fullHost();
                            }

                            if (useSecure) {
                                Log.i(TAG, "connect FTPS:" + amCreateActivity.iHost_FTP + " ...");
                            } else {
                                Log.i(TAG, "connect FTP:" + amCreateActivity.iHost_FTP + " ...");
                            }
                            ftpClient.connect(amCreateActivity.iHost_FTP);
                            if (!FTPReply.isPositiveCompletion(ftpClient
                                    .getReplyCode())) {

                                Log.e(TAG, "connect fail");
                                nextSleepLength = cSLEEP_AFTER_NO_CONNECT;
                                break;
                            }


                            Log.i(TAG, "login as " + amCreateActivity.iHost + " ...");

                            boolean result;

                            result = ftpClient.login(
                                     amCreateActivity.iHost,
                                     amCreateActivity.iPwd);

                            if (!result) {

                                Log.e(TAG, "login fail");
                                nextSleepLength = cSLEEP_AFTER_LOGIN_FAIL;
                                break;
                            }

                            Log.v(TAG, "set " + ftpClient.getSystemType()
                                    + " to passive ...");
                            ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
                            ftpClient.enterLocalPassiveMode();

                            // Destination already reached
                            FTPFile[] rFiles = ftpClient.listFiles(rFile);
                            if (!FTPReply.isPositiveCompletion(ftpClient
                                    .getReplyCode())) {

                                Log.e(TAG, "243: list fails");
                                nextSleepLength = cSLEEP_AFTER_CONNECTION_LOST;
                                break;
                            }
                            if (rFiles.length == 1) {

                                remoteFSize = rFiles[0].getSize();
                                if (localFSize == remoteFSize) {

                                    Log.d(TAG, rFile + " already there ...");

                                    // Store old File Info
                                    // File DeletedFile = files[0];
                                    File newFile = new File(
                                              files[0].getParent(),
                                            ALREADY_UPLOADED_PREFIX + rFile);

                                    // File is already complete uploaded, rename!
                                    if (files[0].renameTo(newFile)) {
                                      galleryRemove(files[0]);
                                      galleryAdd(newFile);
                                    } else {
                                      Log.e(TAG, "369: rename to '" + newFile.getName() + "' failed!");
                                    }

                                    nextSleepLength = cSLEEP_AFTER_UPLAOD_SUCCESS;
                                    break;
                                } else {

                                    // File is already partially uploaded ->
                                    // ignore
                                    // it gets deleted later
                                    Log.d(TAG,
                                            rFile
                                                    + " has "
                                                    + Long.toString(remoteFSize)
                                                    + " Bytes ...");

                                }

                            }

                            // Temporary Destination already there
                            rFiles = ftpClient.listFiles(rFile + cTMP_POSTFIX);
                            if (!FTPReply.isPositiveCompletion(ftpClient
                                    .getReplyCode())) {

                                Log.e(TAG, "267: list fails");
                                nextSleepLength = cSLEEP_AFTER_CONNECTION_LOST;
                                break;
                            }

                            if (rFiles.length == 1) {

                                remoteFSize = rFiles[0].getSize();
                                if (localFSize == remoteFSize) {

                                    // $$$-File is already completely uploaded
                                    Log.d(TAG, rFile + cTMP_POSTFIX
                                            + " upload complete ...");

                                    // delete "old" Version of it (should not
                                    // exists)!
                                    ftpClient.deleteFile(rFile);
                                    if (FTPReply.isPositiveCompletion(ftpClient
                                            .getReplyCode())) {
                                        // File did not exists, thats OK!
                                        Log.i(TAG, "old Version of " + rFile
                                                + " deleted");
                                    }

                                    // Rename it remote!
                                    ftpClient.rename(rFile + cTMP_POSTFIX, rFile);
                                    if (!FTPReply.isPositiveCompletion(ftpClient
                                            .getReplyCode())) {
                                        // Rename Fail! This could be a
                                        // command Pipe Connection lost!
                                        Log.e(TAG, "424: rename to " + rFile + " failed!");
                                        nextSleepLength = cSLEEP_COMMAND_CONNECTION_LOST;
                                        break;
                                    }

                                    File newFile = new File(files[0]
                                            .getParent(),
                                            ALREADY_UPLOADED_PREFIX + rFile);

                                    // mark File as Uploaded
                                    if (files[0].renameTo(newFile)) {
                                        galleryRemove(files[0]);
                                        galleryAdd(newFile);
                                    } else {
                                        Log.e(TAG, "438: rename to '" + newFile.getName() + "' failed!");
                                    }

                                    // delete very old already uploaded Files
                                    File[] filesOld = root
                                            .listFiles(deleteMask);
                                    if (filesOld != null) {
                                        for (File f : filesOld) {
                                            Log.i(TAG, "delete very old, already uploaded Image " + f.getName());
                                            if (f.delete()) {
                                                galleryRemove(f);
                                            } else {
                                                Log.e(TAG, "450: delete '"+f.getName()+"' failed!" );
                                            }
                                        }
                                    }

                                    // OK
                                    soundPool.play(soundOk, 1, 1, 1, 0, 1f);

                                    nextSleepLength = cSLEEP_AFTER_UPLAOD_SUCCESS;
                                    break;
                                }

                                if (remoteFSize > localFSize) {

                                    Log.d(TAG, rFile + cTMP_POSTFIX
                                            + " it too big -> restart ...");

                                    // ups, Danger of "duplicate-Packets"
                                    remoteFSize = 0;
                                }

                                Log.d(TAG,
                                        rFile + cTMP_POSTFIX + " already has "
                                                + Long.toString(remoteFSize)
                                                + " Bytes there ...");

                                // ***************************************
                                // v RESTART IS DEACTIVATED BY NOW - BY THIS
                                // LINE v
                                remoteFSize = 0;
                                // ^ RESTART IS DEACTIVATED BY NOW - BY THIS
                                // LINE ^
                                // ***************************************

                                if (remoteFSize == 0) {

                                    // File there, But no Data
                                    Log.d(TAG, "rm " + rFile + cTMP_POSTFIX);
                                    ftpClient.deleteFile(rFile + cTMP_POSTFIX);

                                }
                                // File is already partially uploaded
                                // It gets deleted later
                            } else {
                                remoteFSize = 0;
                            }

                            // open File
                            InputStream input = new FileInputStream(lFile);
                            if (remoteFSize != 0) {

                                ftpClient.setRestartOffset(remoteFSize);
                                input.skip(remoteFSize);
                            }

                            // Beep, because we start now
                            Log.i(TAG, "upload '" + lFile + "' as '" + rFile
                                    + "' " + Long.toString(localFSize));
                            soundPool.play(soundBeep, 1, 1, 1, 0, 1f);

                            // This my take a looooooooong time
                            ftpClient.storeFile(rFile + cTMP_POSTFIX, input);
                            input.close();

                            // World changed so much since then
                            // Doing anything is not a good idea

                            nextSleepLength = cSLEEP_AFTER_UPLAOD_SUCCESS;
                            break;

                        } catch (Exception e) {
                            Log.e(TAG, "520: ", e);
                            nextSleepLength = cSLEEP_AFTER_EXCEPTION;
                            break;
                        }

                    } catch (Exception e) {
                        Log.e(TAG, "526: ", e);
                        nextSleepLength = cSLEEP_AFTER_CONNECTION_LOST;
                    }
                    break;
                }

                try {

                    // Clean up and Sleep
                    try {
                        if (ftpClient.isConnected()) {
                            ftpClient.disconnect();
                        }
                    } catch (IOException e) {
                        // Quite normal, do nothing!
                        Log.e(TAG, "disconnect", e);
                    }
                    ftpClient = null;
                    ftpsClient = null;

                    // Sleep for a minimum of Time, don't care what people say
                    // and Sleep extra Time
                    Thread.sleep(500 + nextSleepLength * 1000);

                } catch (InterruptedException e) {
                    Log.e(TAG, "551: ", e);
                    runs = false;
                }
            }
        }
    }
}
