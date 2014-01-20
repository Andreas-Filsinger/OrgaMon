{**************************************************************************************}
{                                                                                      }
{ CCR Exif - Delphi class library for reading and writing Exif metadata in JPEG files  }
{ Version 0.9.9 (2009-11-19)                                                           }
{                                                                                      }
{ The contents of this file are subject to the Mozilla Public License Version 1.1      }
{ (the "License"); you may not use this file except in compliance with the License.    }
{ You may obtain a copy of the License at http://www.mozilla.org/MPL/                  }
{                                                                                      }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT   }
{ WARRANTY OF ANY KIND, either express or implied. See the License for the specific    }
{ language governing rights and limitations under the License.                         }
{                                                                                      }
{ The Original Code is CCR.Exif.TagIDs.pas.                                            }
{                                                                                      }
{ The Initial Developer of the Original Code is Chris Rolliston. Portions created by   }
{ Chris Rolliston are Copyright (C) 2009 Chris Rolliston. All Rights Reserved.         }
{                                                                                      }
{**************************************************************************************}

unit CCR.Exif.TagIDs;

interface

const
  { Exif main directory tags }
  ttImageDescription          = $010E;
  ttMake                      = $010F;
  ttModel                     = $0110;
  ttOrientation               = $0112;
  ttXResolution               = $011A;
  ttYResolution               = $011B;
  ttResolutionUnit            = $0128;
  ttSoftware                  = $0131;
  ttDateTime                  = $0132;
  ttArtist                    = $013B;
  ttWhitePoint                = $013E;
  ttPrimaryChromaticities     = $013F;
  ttYCbCrCoefficients         = $0211;
  ttYCbCrPositioning          = $0213;
  ttReferenceBlackWhite       = $0214;
  ttCopyright                 = $8298;
  ttExifOffset                = $8769;
  ttGPSOffset                 = $8825;
  ttPrintIM                   = $C4A5;

  { Additional Exif main directory tags supported by Windows Explorer - for all but
    ttWindowsRating, the data type is tdByte and the content null-terminated UTF16LE,
    even when the Exif block as a whole is big endian. }
  ttWindowsTitle              = $9C9B;
  ttWindowsComments           = $9C9C;
  ttWindowsAuthor             = $9C9D; //Vista's Windows Explorer will check for ttArtist too, though only sets this
  ttWindowsKeywords           = $9C9E; //'Tags' in the UI
  ttWindowsSubject            = $9C9F;
  ttWindowsRating             = $4746; //word value, despite being out of 5

  { Padding tag patented (!) by MS (http://www.freepatentsonline.com/7421451.html) }
  ttWindowsPadding            = $EA1C;

  { Exif sub-directory tags }
  ttExposureTime              = $829A;
  ttFNumber                   = $829D;
  ttExposureProgram           = $8822; //1 = manual, 2 = normal, 3 = aperture priority, 4 = shutter priority, 5 = creative, 6 = action, 7 = portrait mode, 8 = landscape mode
  ttSpectralSensitivity       = $8824;
  ttISOSpeedRatings           = $8827;
  ttExifVersion               = $9000;
  ttDateTimeOriginal          = $9003;
  ttDateTimeDigitized         = $9004;
  ttComponentsConfiguration   = $9101;
  ttCompressedBitsPerPixel    = $9102;
  ttShutterSpeedValue         = $9201;
  ttApertureValue             = $9202;
  ttBrightnessValue           = $9203;
  ttExposureBiasValue         = $9204;
  ttMaxApertureValue          = $9205;
  ttSubjectDistance           = $9206;
  ttMeteringMode              = $9207;
  ttLightSource               = $9208;
  ttFlash                     = $9209; //0 = didn't fire, 1 = fired, 2 = fired but strobe return light not detected, 7 = flash fired and strobe return light detected
  ttFocalLength               = $920A; //in millimetres
  ttSubjectArea               = $9214;
  ttMakerNote                 = $927C;
  ttUserComment               = $9286;
  ttSubsecTime                = $9290;
  ttSubsecTimeOriginal        = $9291;
  ttSubsecTimeDigitized       = $9292;
  ttFlashPixVersion           = $A000;
  ttColorSpace                = $A001;
  ttExifImageWidth            = $A002;
  ttExifImageHeight           = $A003;
  ttRelatedSoundFile          = $A004;
  ttInteropOffset             = $A005;
  ttFlashEnergy               = $A20B;
  ttSpatialFrequencyResponse  = $A20C;
  ttFocalPlaneXResolution     = $A20E;
  ttFocalPlaneYResolution     = $A20F;
  ttFocalPlaneResolutionUnit  = $A210;
  ttSubjectLocation           = $A214;
  ttExposureIndex             = $A215;
  ttSensingMethod             = $A217;
  ttFileSource                = $A300; //$03 = digital still camera
  ttSceneType                 = $A301; //$01 = directly photographed
  ttCFAPattern                = $A302;
  ttCustomRendered            = $A401;
  ttExposureMode              = $A402;
  ttWhiteBalance              = $A403;
  ttDigitalZoomRatio          = $A404;
  ttFocalLengthIn35mmFilm     = $A405;
  ttSceneCaptureType          = $A406;
  ttGainControl               = $A407;
  ttContrast                  = $A408;
  ttSaturation                = $A409;
  ttSharpness                 = $A40A;
  ttDeviceSettingDescription  = $A40B;
  ttSubjectDistanceRange      = $A40C;
  ttImageUniqueID             = $A420;

  { MakerNote tag data offset relative to where it originally was; tag defined by MS }
  ttOffsetSchema              = $EA1D;

  { Exif interoperability sub-directory tags }
  ttInteropIndex              = $0001;
  ttInteropVersion            = $0002;
  ttRelatedImageFileFormat    = $1000;
  ttRelatedImageWidth         = $1001;
  ttRelatedImageLength        = $1002;

  { GPS sub-directory tags }
  ttGPSVersionID              = $0000;
  ttGPSLatitudeRef            = $0001;
  ttGPSLatitude               = $0002;
  ttGPSLongitudeRef           = $0003;
  ttGPSLongitude              = $0004;
  ttGPSAltitudeRef            = $0005;
  ttGPSAltitude               = $0006;
  ttGPSTimeStamp              = $0007;
  ttGPSSatellites             = $0008;
  ttGPSStatus                 = $0009;
  ttGPSMeasureMode            = $000A;
  ttGPSDOP                    = $000B;
  ttGPSSpeedRef               = $000C;
  ttGPSSpeed                  = $000D;
  ttGPSTrackRef               = $000E;
  ttGPSTrack                  = $000F;
  ttGPSImgDirectionRef        = $0010;
  ttGPSImgDirection           = $0011;
  ttGPSMapDatum               = $0012;
  ttGPSDestLatitudeRef        = $0013;
  ttGPSDestLatitude           = $0014;
  ttGPSDestLongitudeRef       = $0015;
  ttGPSDestLongitude          = $0016;
  ttGPSDestBearingRef         = $0017;
  ttGPSDestBearing            = $0018;
  ttGPSDestDistanceRef        = $0019;
  ttGPSDestDistance           = $001A;
  ttGPSProcessingMethod       = $001B;
  ttGPSAreaInformation        = $001C;
  ttGPSDateStamp              = $001D;
  ttGPSDifferential           = $001E;

  { Exif thumbnail directory tags }
  ttImageWidth                = $0100; //shouldn't be used for a JPEG thumbnail
  ttImageHeight               = $0101; //shouldn't be used for a JPEG thumbnail
  ttBitsPerSample             = $0102; //shouldn't be used for a JPEG thumbnail
  ttCompression               = $0103; //value should be 6 for JPEG (1 = uncompressed TIFF
  ttPhotometricInterp         = $0106; //1=b/w, 2 = RGB, 6 = YCbCr; shouldn't be used for a JPEG thumbnail
  ttStripOffset               = $0111; //for when thumbnail is a TIFF
  ttSamplesPerPixel           = $0115; //shouldn't be used for a JPEG thumbnail
  ttRowsPerStrip              = $0116; //shouldn't be used for a JPEG thumbnail
  ttStripByteCount            = $0117; //for when thumbnail is a TIFF
  ttPlanarConfiguration       = $011C; //shouldn't be used for a JPEG thumbnail
  ttJpegIFOffset              = $0201;
  ttJpegIFByteCount           = $0202;
  ttThumbnailOffset = ttJpegIFOffset;
  ttThumbnailSize = ttJpegIFByteCount;

  { Cannon MakerNote tags }
  ttCanonCameraSettings     = $0001;
  ttCanonFocalLength        = $0002;
  ttCanonFlashInfo          = $0003;
  ttCanonShotInfo           = $0004;
  ttCanonPanorama           = $0005;
  ttCanonImageType          = $0006; //tdAscii
  ttCanonFirmwareVersion    = $0007; //tdAscii
  ttCanonFileNumber         = $0008; //tdLongWord
  ttCanonOwnerName          = $0009; //tdAscii
  ttCanonSerialNumber       = $000C; //tdLongWord
  ttCanonCameraInfo         = $000D;
  ttCanonFileLength         = $000E; //tdLongWord
  ttCanonFunctions          = $000F;
  ttCanonModelID            = $0010; //tdLongWord
  ttCanonAFInfo             = $0012;
  ttCanonValidThumbnailArea = $0013; //tdWord x 4; all zeros for full frame
  ttCanonSerialNumberFormat = $0015; //tdLongWord
  ttCanonSuperMacro         = $001A; //tdWord (0 = off, 1 = on (1) 2 = on (2)
  ttCanonDateStampMode      = $001C; //tdWord (0 = off, 1 = date, 2 = date and time
  ttCanonMyColors           = $001D;
  ttCanonFirmwareRevision   = $001E; //tdLongWord
  ttCanonCategories         = $0023; //tdLongWord x 2 (first value always 8)

  { Panasonic MakerNote tags }
  ttPanasonicImageQuality       = $0001;
  ttPanasonicFirmwareVersion    = $0002;
  ttPanasonicWhiteBalance       = $0003;
  ttPanasonicFocusMode          = $0007;
  ttPanasonicSpotMode           = $000F;
  ttPanasonicImageStabilizer    = $001A;
  ttPanasonicMacroMode          = $001C;
  ttPanasonicShootingMode       = $001F;
  ttPanasonicAudio              = $0020;
  ttPanasonicDataDump           = $0021;
  ttPanasonicWhiteBalanceBias   = $0023;
  ttPanasonicFlashBias          = $0024;
  ttPanasonicInternalSerialNum  = $0025;
  ttPanasonicExifVersion        = $0026;
  ttPanasonicColorEffect        = $0028;
  ttPanasonicTimeSincePowerOn   = $0029;
  ttPanasonicBurstMode          = $002A;
  ttPanasonicSequenceNumber     = $002B;
  ttPanasonicContrastMode       = $002C;
  ttPanasonicNoiseReduction     = $002D;
  ttPanasonicSelfTimer          = $002E;
  ttPanasonicRotation           = $0030;
  ttPanasonicAFAssistLamp       = $0031;
  ttPanasonicColorMode          = $0032;
  ttPanasonicBabyOrPetAge1      = $0033;
  ttPanasonicOpticalZoomMode    = $0034;
  ttPanasonicConversionLens     = $0035;
  ttPanasonicTravelDay          = $0036;
  ttPanasonicWorldTimeLocation  = $003A;
  ttPanasonicTextStamp1         = $003B;
  ttPanasonicProgramISO         = $003C;
  ttPanasonicSaturation         = $0040;
  ttPanasonicSharpness          = $0041;
  ttPanasonicFilmMode           = $0042;
  ttPanasonicWBAdjustAB         = $0046;
  ttPanasonicWBAdjustGM         = $0047;
  ttPanasonicLensType           = $0051;
  ttPanasonicLensSerialNumber   = $0052;
  ttPanasonicAccessoryType      = $0053;
  ttPanasonicMakerNoteVersion   = $8000;
  ttPanasonicSceneMode          = $8001;
  ttPanasonicWBRedLevel         = $8004;
  ttPanasonicWBGreenLevel       = $8005;
  ttPanasonicWBBlueLevel        = $8006;
  ttPanasonicTextStamp2         = $8008;
  ttPanasonicTextStamp3         = $8009;
  ttPanasonicBabyOrPetAge2      = $8010;

implementation

end.
