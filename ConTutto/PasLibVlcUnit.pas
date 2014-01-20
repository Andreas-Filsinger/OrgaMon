(*
 * PasLibVlcUnit.pas - pascal interface for libvlc 2.0.3
 *
 * See copyright notice below.
 *
 * Last modified: 2012.07.21
 *
 * author: Robert Jędrzejczyk
 * e-mail: robert@prog.olsztyn.pl
 *    www: http://www.prog.olsztyn.pl/paslibvlc
 *
 *******************************************************************************
 *
 * 2012.07.21 Robert Jędrzejczyk
 *
 * Add new functions from libvlc 2.0.3
 *
 * libvlc_set_exit_handler
 * libvlc_free
 * libvlc_module_description_list_release
 * libvlc_audio_filter_list_get
 * libvlc_video_filter_list_get
 * libvlc_clock
 * libvlc_media_list_player_retain
 * libvlc_video_set_format_callbacks
 * libvlc_video_get_spu_delay
 * libvlc_video_set_spu_delay
 * libvlc_audio_set_callbacks
 * libvlc_audio_set_volume_callback
 * libvlc_audio_set_format_callbacks
 * libvlc_audio_set_format
 * libvlc_media_player_navigate
 *
 *******************************************************************************
 *
 * 2011.08.22 "Maloupi" <maloupi@2n-tech.com>
 *
 * Crossplatform modifications (Linux)
 *
 *******************************************************************************
 *
 * 2011.08.20 Robert Jędrzejczyk
 *
 * Add new function:
 *
 *    libvlc_dynamic_dll_init_with_path(vlc_install_path: string);
 *
 *******************************************************************************
 *
 * 2010.12.08 Robert Jędrzejczyk
 *
 * Add new functions from libvlc 1.1.5
 *
 * libvlc_media_new_fd
 *
 *******************************************************************************
 *
 * 2010.11.24 Alexey lelikz@users.sourceforge.net
 *
 * incorrect declaration in functions:
 * lock_call_fun
 * unlock_call_fun
 * display_call_fun
 * stdcall calling convention instead of cdecl
 *
 *******************************************************************************
 *
 * 2010.09.07 Alain Gawlik a.gawlik@gmx.com
 * incorrect declaration of function
 * libvlc_log_iterator_has_next
 * missing calling convention (cdecl)
 *
 *******************************************************************************
 *
 * 2010.09.06 Alain Gawlik a.gawlik@gmx.com
 *
 * incorrect declaration in function
 * libvlc_media_player_set_hwnd
 * stdcall calling convention instead of cdecl
 *
 *******************************************************************************
 *
 * 2010.09.02 Robert Jędrzejczyk
 *
 * Add support for libvlc 1.1.4
 *
 *******************************************************************************
 *
 * 2010.07.22 Robert Jędrzejczyk
 *
 * Add new functions from libvlc 1.1.1
 *
 * libvlc_set_user_agent
 * libvlc_media_player_set_pause
 * libvlc_video_set_callbacks
 * libvlc_video_set_format
 * libvlc_video_get_adjust_int
 * libvlc_video_set_adjust_int
 * libvlc_video_get_adjust_float
 * libvlc_video_set_adjust_float
 * libvlc_audio_get_delay
 * libvlc_audio_set_delay
 *
 *******************************************************************************
 *
 * 2010.07.14 David Nottage, davidnottage@gmail.com
 *
 * Change PChar to PAnsiChar
 * This help usage in Delphi 2010
 *
 *******************************************************************************
 *
 * 2010.07.13 David Nottage, davidnottage@gmail.com
 *
 * Change registry read mode from default KEY_ALL_ACCESS to KEY_READ.
 * This help open registry key if you not logged as administrator
 *
 *******************************************************************************
 *
 *)

(* This is file is part of PasLibVlcPlayer component
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Any non-GPL usage of this software or parts of this software is strictly
 * forbidden.
 *
 * The "appropriate copyright message" mentioned in section 2c of the GPLv2
 * must read: "Code from FAAD2 is copyright (c) Nero AG, www.nero.com"
 *
 * Commercial non-GPL licensing of this software is possible.
 * please contact robert@prog.olsztyn.pl
 *
 *)

(*
 * libvlc is part of project VideoLAN
 *
 * Copyright (c) 1996-2010 VideoLAN Team
 *
 * For more information about VideoLAN
 *
 * please visit http://www.videolan.org
 *
 *)

{$I compiler.inc}

{$A8,Z4}

unit PasLibVlcUnit;

interface

(**
 * Real path to libvlc.dll
 *)

var
  libvlc_dynamic_dll_path: string;

(**
 * Last error message generated by LibVlc_Init() procedure
 *)
 
var
  libvlc_dynamic_dll_error: string;

(**
 * Dynamic loading libvlc.dll
 * Must be called before use any libvlc function
 *)

procedure libvlc_dynamic_dll_init();
procedure libvlc_dynamic_dll_init_with_path(vlc_install_path: string);

(**
 * Release libvlc.dll
 *)
 
procedure libvlc_dynamic_dll_done();

(*
 *******************************************************************************
 * type s and structures used in libvlc
 *******************************************************************************
 *)

type
  libvlc_instance_t_ptr          = type Pointer;
  libvlc_log_t_ptr               = type Pointer;
  libvlc_log_iterator_t_ptr      = type Pointer;
  libvlc_media_t_ptr             = type Pointer;
  libvlc_media_player_t_ptr      = type Pointer;
  libvlc_media_list_t_ptr        = type Pointer;
  libvlc_media_list_player_t_ptr = type Pointer;
  libvlc_media_library_t_ptr     = type Pointer;
  libvlc_media_discoverer_t_ptr  = type Pointer;
  libvlc_event_manager_t_ptr     = type Pointer;


type
  libvlc_time_t_ptr = ^libvlc_time_t;
  libvlc_time_t = int64;

type
  libvlc_log_message_t_ptr = ^libvlc_log_message_t;
  libvlc_log_message_t = record
    i_severity  : Integer;   (* 0=INFO, 1=ERR, 2=WARN, 3=DBG   *)
    psz_type    : PAnsiChar; (* module type                    *)
    psz_name    : PAnsiChar; (* module name                    *)
    psz_header  : PAnsiChar; (* optional header                *)
    psz_message : PAnsiChar; (* message                        *)
  end;

type
  libvlc_meta_t = (
    libvlc_meta_Title,
    libvlc_meta_Artist,
    libvlc_meta_Genre,
    libvlc_meta_Copyright,
    libvlc_meta_Album,
    libvlc_meta_TrackNumber,
    libvlc_meta_Description,
    libvlc_meta_Rating,
    libvlc_meta_Date,
    libvlc_meta_Setting,
    libvlc_meta_URL,
    libvlc_meta_Language,
    libvlc_meta_NowPlaying,
    libvlc_meta_Publisher,
    libvlc_meta_EncodedBy,
    libvlc_meta_ArtworkURL,
    libvlc_meta_TrackID
    // Add new meta types HERE
);

type
  libvlc_state_t = (
    libvlc_NothingSpecial = 0,
    libvlc_Opening        = 1,
    libvlc_Buffering      = 2,
    libvlc_Playing        = 3,
    libvlc_Paused         = 4,
    libvlc_Stopped        = 5,
    libvlc_Ended          = 6,
    libvlc_Error          = 7
);

const
  libvlc_media_option_trusted = $0002;
  libvlc_media_option_unique  = $0100;

type
  libvlc_track_type_t = (
    libvlc_track_unknown = -1,
    libvlc_track_audio   = 0,
    libvlc_track_video   = 1,
    libvlc_track_text    = 2
);

type
  libvlc_media_stats_t_ptr = ^libvlc_media_stats_t;
  libvlc_media_stats_t = record
    // Input
    i_read_bytes          : Integer;
    f_input_bitrate       : Single; // Float
    // Demux
    i_demux_read_bytes    : Integer;
    f_demux_bitrate       : Single;
    i_demux_corrupted     : Integer;
    i_demux_discontinuity : Integer;
    // Decoders
    i_decoded_video       : Integer;
    i_decoded_audio       : Integer;
    // Video Output
    i_displayed_pictures  : Integer;
    i_lost_pictures       : Integer;
    // Audio output
    i_played_abuffers     : Integer;
    i_lost_abuffers       : Integer;
    // Stream output
    i_sent_packets        : Integer;
    i_sent_bytes          : Integer;
    f_send_bitrate        : Single;
  end;

type
  libvlc_media_track_info_t_audio = record
    i_channels : LongWord;
    i_rate     : LongWord
  end;

type
  libvlc_media_track_info_t_video = record
    i_height : LongWord;
    i_width  : LongWord;
  end;

type
  libvlc_media_track_info_t_ptr = ^libvlc_media_track_info_t;
  libvlc_media_track_info_t = record
    // Codec fourcc
    i_codec : LongWord;
    i_id    : Integer;
    i_type  : libvlc_track_type_t;

    // Codec specific
    i_profile : Integer;
    i_level   : Integer;

    case Byte of
      0: (audio : libvlc_media_track_info_t_audio);
      1: (video : libvlc_media_track_info_t_video);
  end;

type
  libvlc_track_description_t_ptr = ^libvlc_track_description_t;
  libvlc_track_description_t = record
    i_id     : Integer;
    psz_name : PAnsiChar;
    p_next   : libvlc_track_description_t_ptr;
 end;

type
  libvlc_audio_output_t_ptr = ^libvlc_audio_output_t;
  libvlc_audio_output_t = record
    psz_name        : PAnsiChar;
    psz_description : PAnsiChar;
    p_next          : libvlc_audio_output_t_ptr;
  end;

type
  libvlc_rectangle_t_ptr = ^libvlc_rectangle_t;
  libvlc_rectangle_t = record
    top    :    Integer;
    left   :   Integer;
    bottom : Integer;
    right  :  Integer;
  end;

type
  libvlc_video_marquee_option_t = (
    libvlc_marquee_Enable = 0,
    libvlc_marquee_Text,		// string argument
    libvlc_marquee_Color,
    libvlc_marquee_Opacity,
    libvlc_marquee_Position,
    libvlc_marquee_Refresh,
    libvlc_marquee_Size,
    libvlc_marquee_Timeout,
    libvlc_marquee_X,
    libvlc_marquee_Y
  );

const
  libvlc_video_marquee_color_Default = $f0000000;
  libvlc_video_marquee_color_Black   = $00000000;
  libvlc_video_marquee_color_Gray    = $00808080;
  libvlc_video_marquee_color_Silver  = $00C0C0C0;
  libvlc_video_marquee_color_White   = $00FFFFFF;
  libvlc_video_marquee_color_Maroon  = $00800000;
  libvlc_video_marquee_color_Red     = $00FF0000;
  libvlc_video_marquee_color_Fuchsia = $00FF00FF;
  libvlc_video_marquee_color_Yellow  = $00FFFF00;
  libvlc_video_marquee_color_Olive   = $00808000;
  libvlc_video_marquee_color_Green   = $00008000;
  libvlc_video_marquee_color_Teal    = $00008080;
  libvlc_video_marquee_color_Lime    = $0000FF00;
  libvlc_video_marquee_color_Purple  = $00800080;
  libvlc_video_marquee_color_Navy    = $00000080;
  libvlc_video_marquee_color_Blue    = $000000FF;
  libvlc_video_marquee_color_Aqua    = $0000FFFF;

const
  libvlc_video_marquee_opacity_none   = 0;
  libvlc_video_marquee_opacity_medium = 128;
  libvlc_video_marquee_opacity_full   = 255;

const
  libvlc_video_marquee_position_Center       = 0;
  libvlc_video_marquee_position_Left         = 1;
  libvlc_video_marquee_position_Right        = 2;
  libvlc_video_marquee_position_Top          = 3;
  libvlc_video_marquee_position_Bottom       = 4;
  libvlc_video_marquee_position_Top_Left     = 5;
  libvlc_video_marquee_position_Top_Right    = 6;
  libvlc_video_marquee_position_Bottom_Left  = 7;
  libvlc_video_marquee_position_Bottom_Right = 8;

type
  libvlc_video_logo_option_t = (
    libvlc_logo_enable,
    libvlc_logo_file,           // < string argument, "file,d,t;file,d,t;..."
    libvlc_logo_x,
    libvlc_logo_y,
    libvlc_logo_delay,
    libvlc_logo_repeat,
    libvlc_logo_opacity,
    libvlc_logo_position
 );

(**
 * Audio device types
 *)

type
  libvlc_audio_output_device_types_t = (
    libvlc_AudioOutputDevice_Error  = -1,
    libvlc_AudioOutputDevice_Mono   =  1,
    libvlc_AudioOutputDevice_Stereo =  2,
    libvlc_AudioOutputDevice_2F2R   =  4,
    libvlc_AudioOutputDevice_3F2R   =  5,
    libvlc_AudioOutputDevice_5_1    =  6,
    libvlc_AudioOutputDevice_6_1    =  7,
    libvlc_AudioOutputDevice_7_1    =  8,
    libvlc_AudioOutputDevice_SPDIF  = 10);

type
  libvlc_audio_output_channel_t = (
    libvlc_AudioChannel_Error   = -1,
    libvlc_AudioChannel_Stereo  =  1,
    libvlc_AudioChannel_RStereo =  2,
    libvlc_AudioChannel_Left    =  3,
    libvlc_AudioChannel_Right   =  4,
    libvlc_AudioChannel_Dolbys  =  5
  );

type
  libvlc_playback_mode_t = (
    libvlc_playback_mode_default,
    libvlc_playback_mode_loop,
    libvlc_playback_mode_repeat
  );

(**
 * Navigation mode
 *)
type
  libvlc_navigate_mode_t = (
    libvlc_navigate_activate = 0,
    libvlc_navigate_up,
    libvlc_navigate_down,
    libvlc_navigate_left,
    libvlc_navigate_right
  );

(*
 ******************************************************************************
 * libvlc_event.h
 *******************************************************************************
 *)

type
  libvlc_event_type_t = (
    (* Append new event types at the end of a category.
     * Do not remove, insert or re-order any entry.
     * Keep this in sync with src/control/event.c:libvlc_event_type_name(). *)
    libvlc_MediaMetaChanged = 0,
    libvlc_MediaSubItemAdded,
    libvlc_MediaDurationChanged,
    libvlc_MediaParsedChanged,
    libvlc_MediaFreed,
    libvlc_MediaStateChanged,

    libvlc_MediaPlayerMediaChanged = $100,
    libvlc_MediaPlayerNothingSpecial,
    libvlc_MediaPlayerOpening,
    libvlc_MediaPlayerBuffering,
    libvlc_MediaPlayerPlaying,
    libvlc_MediaPlayerPaused,
    libvlc_MediaPlayerStopped,
    libvlc_MediaPlayerForward,
    libvlc_MediaPlayerBackward,
    libvlc_MediaPlayerEndReached,
    libvlc_MediaPlayerEncounteredError,
    libvlc_MediaPlayerTimeChanged,
    libvlc_MediaPlayerPositionChanged,
    libvlc_MediaPlayerSeekableChanged,
    libvlc_MediaPlayerPausableChanged,
    libvlc_MediaPlayerTitleChanged,
    libvlc_MediaPlayerSnapshotTaken,
    libvlc_MediaPlayerLengthChanged,
    libvlc_MediaPlayerVout,

    libvlc_MediaListItemAdded = $200,
    libvlc_MediaListWillAddItem,
    libvlc_MediaListItemDeleted,
    libvlc_MediaListWillDeleteItem,

    libvlc_MediaListViewItemAdded = $300,
    libvlc_MediaListViewWillAddItem,
    libvlc_MediaListViewItemDeleted,
    libvlc_MediaListViewWillDeleteItem,

    libvlc_MediaListPlayerPlayed = $400,
    libvlc_MediaListPlayerNextItemSet,
    libvlc_MediaListPlayerStopped,

    libvlc_MediaDiscovererStarted = $500,
    libvlc_MediaDiscovererEnded,

    libvlc_VlmMediaAdded = $600,
    libvlc_VlmMediaRemoved,
    libvlc_VlmMediaChanged,
    libvlc_VlmMediaInstanceStarted,
    libvlc_VlmMediaInstanceStopped,
    libvlc_VlmMediaInstanceStatusInit,
    libvlc_VlmMediaInstanceStatusOpening,
    libvlc_VlmMediaInstanceStatusPlaying,
    libvlc_VlmMediaInstanceStatusPause,
    libvlc_VlmMediaInstanceStatusEnd,
    libvlc_VlmMediaInstanceStatusError
  );

(*
 * Types below declared only for preserve structure of libvlc_event_t record
 *)

type
  event_media_meta_changed_t = record
    meta_type : libvlc_meta_t;
  end;

type
  event_media_subitem_added_t = record
    new_child : libvlc_media_t_ptr;
  end;

type
  event_media_duration_changed_t = record
    new_duration : Int64;
  end;

type
  media_parsed_changed_t = record
    new_status : Integer;
  end;

type
  media_freed_t = record
    md : libvlc_media_t_ptr;
  end;

type
  media_state_changed_t = record
    new_state : libvlc_state_t;
  end;

type
  media_player_buffering_t = record
    new_cache : Single; // float
  end;

type
  media_player_media_changed_t = record
    new_media : libvlc_media_t_ptr;
  end;

type
  media_player_time_changed_t = record
    new_time : libvlc_time_t;
  end;
  
type
  media_player_position_changed_t = record
    new_position : Single; // float
  end;

type
  media_player_seekable_changed_t = record
    new_seekable : Integer;
  end;

type
  media_player_pausable_changed_t = record
    new_pausable : Integer;
  end;

type
  media_player_vout_t = record
    new_count : Integer;
  end;

type
  media_player_snapshot_taken_t = record
    psz_filename : PAnsiChar;
  end;

type
  media_player_length_changed_t = record
    new_length : libvlc_time_t;
  end;

type
  media_player_title_changed_t = record
    new_title : Integer;
  end;

type
  media_list_item_added_t = record
    item  : libvlc_media_t_ptr;
    index : Integer;
  end;

type
  media_list_will_add_item_t = record
    item  : libvlc_media_t_ptr;
    index : Integer;
  end;

type
  media_list_item_deleted_t = record
    item  : libvlc_media_t_ptr;
    index : Integer;
  end;

type
  media_list_will_delete_item_t = record
    item  : libvlc_media_t_ptr;
    index : Integer;
  end;

type
  media_list_player_next_item_set_t = record
    item : libvlc_media_t_ptr;
  end;

type
  vlm_media_event_t = record
    psz_media_name    : PAnsiChar;
    psz_instance_name : PAnsiChar;
  end;

type
  libvlc_event_t_ptr = ^libvlc_event_t;
  libvlc_event_t = record
    event_type : libvlc_event_type_t;
    p_obj      : Pointer;              (* Object emitting the event *)
    
    case libvlc_event_type_t of

    libvlc_MediaMetaChanged           : (media_meta_changed              : event_media_meta_changed_t);
    libvlc_MediaSubItemAdded          : (media_subitem_added             : event_media_subitem_added_t);
    libvlc_MediaDurationChanged       : (media_duration_changed          : event_media_duration_changed_t);
    libvlc_MediaParsedChanged         : (media_parsed_changed            : media_parsed_changed_t);
    libvlc_MediaFreed                 : (media_freed                     : media_freed_t);
    libvlc_MediaStateChanged          : (media_state_changed             : media_state_changed_t);
    libvlc_MediaPlayerBuffering       : (media_player_buffering          : media_player_buffering_t);

    libvlc_MediaPlayerMediaChanged    : (media_player_media_changed      : media_player_media_changed_t);
    libvlc_MediaPlayerTimeChanged     : (media_player_time_changed       : media_player_time_changed_t);
    libvlc_MediaPlayerPositionChanged : (media_player_position_changed   : media_player_position_changed_t);
    libvlc_MediaPlayerSeekableChanged : (media_player_seekable_changed   : media_player_seekable_changed_t);
    libvlc_MediaPlayerPausableChanged : (media_player_pausable_changed   : media_player_pausable_changed_t);
    libvlc_MediaPlayerVout            : (media_player_vout               : media_player_vout_t);

    libvlc_MediaPlayerTitleChanged    : (media_player_title_changed      : media_player_title_changed_t);
    libvlc_MediaPlayerSnapshotTaken   : (media_player_snapshot_taken     : media_player_snapshot_taken_t);
    libvlc_MediaPlayerLengthChanged   : (media_player_length_changed     : media_player_length_changed_t);

    libvlc_MediaListItemAdded         : (media_list_item_added           : media_list_item_added_t);
    libvlc_MediaListWillAddItem       : (media_list_will_add_item        : media_list_will_add_item_t);
    libvlc_MediaListItemDeleted       : (media_list_item_deleted         : media_list_item_deleted_t);
    libvlc_MediaListWillDeleteItem    : (media_list_will_delete_item     : media_list_will_delete_item_t);

    libvlc_MediaListPlayerNextItemSet : (media_list_player_next_item_set : media_list_player_next_item_set_t);

    libvlc_VlmMediaAdded,
    libvlc_VlmMediaRemoved,
    libvlc_VlmMediaChanged,
    libvlc_VlmMediaInstanceStarted,
    libvlc_VlmMediaInstanceStopped,
    libvlc_VlmMediaInstanceStatusInit,
    libvlc_VlmMediaInstanceStatusOpening,
    libvlc_VlmMediaInstanceStatusPlaying,
    libvlc_VlmMediaInstanceStatusPause,
    libvlc_VlmMediaInstanceStatusEnd,
    libvlc_VlmMediaInstanceStatusError : (vlm_media_event                : vlm_media_event_t);
  end;

(**
 * Callback function notification
 * param p_event the event triggering the callback
 *)

type
   libvlc_event_callback_t = procedure(
     p_event : libvlc_event_t_ptr;
     data    :  Pointer
   ); cdecl;

(**
 * Option flags for libvlc_media_add_option_flag
 *)

type
  input_item_option_e = (
    // Allow VLC to trust the given option.
    // By default options are untrusted
    VLC_INPUT_OPTION_TRUSTED = $0002,

    // Change the value associated to an option if already present,
    // otherwise add the option
    VLC_INPUT_OPTION_UNIQUE  = $0100
  );

(*
 *******************************************************************************
 * libvlc.h
 *******************************************************************************
 *)

(**
 * A human-readable error message for the last LibVLC error in the calling
 * thread. The resulting string is valid until another error occurs (at least
 * until the next LibVLC call).
 *
 * @warning
 * This will be NULL if there was no error.
 *)

 var
   libvlc_errmsg : function() : PAnsiChar; cdecl;

(**
 * Clears the LibVLC error status for the current thread. This is optional.
 * By default, the error status is automatically overriden when a new error
 * occurs, and destroyed when the thread exits.
 *)

var
  libvlc_clearerr : procedure(); cdecl;

(**
 * Sets the LibVLC error status and message for the current thread.
 * Any previous error is overriden.
 * @return a nul terminated string in any case
 *)

var
  libvlc_vprinterr : function(
    fmt : PAnsiChar;
    ap  : array of const
  ) : PAnsiChar; cdecl;

(**
 * Sets the LibVLC error status and message for the current thread.
 * Any previous error is overriden.
 *
 * @return a nul terminated string in any case
 *)

var
  libvlc_printerr : function(
    fmt : PAnsiChar
  ) : PAnsiChar; cdecl;

(**
 * Create and initialize a libvlc instance.
 *
 * param argc the number of arguments
 * param argv command-line-type arguments
 * @return the libvlc instance or NULL in case of error
 *)
var
  libvlc_new : function(
    argc : Integer;
    args : PPAnsiChar
  ) : libvlc_instance_t_ptr; cdecl;

(**
 * Decrement the reference count of a libvlc instance, and destroy it
 * if it reaches zero.
 *
 * param p_libvlc_instance the instance to destroy
 *)

var
  libvlc_release : procedure(
    p_instance : libvlc_instance_t_ptr
  ); cdecl;

(**
 * Increments the reference count of a libvlc instance.
 * The initial reference count is 1 after libvlc_new() returns.
 *
 * param p_instance the instance to reference
 *)

var
  libvlc_retain : procedure(
    p_instance : libvlc_instance_t_ptr
  ); cdecl;

(**
 * Try to start a user interface for the libvlc instance.
 *
 * param p_instance the instance
 * param name interface name, or NULL for default
 * @return 0 on success, -1 on error.
 *)

var
  libvlc_add_intf : function(
    p_instance : libvlc_instance_t_ptr;
    name              : PAnsiChar
  ) : Integer; cdecl;

(**
 * Registers a callback for the LibVLC exit event. This is mostly useful if
 * you have started at least one interface with libvlc_add_intf().
 * Typically, this function will wake up your application main loop (from
 * another thread).
 *
 * param p_instance LibVLC instance
 * param cb callback to invoke when LibVLC wants to exit
 * param opaque data pointer for the callback
 * warning This function and libvlc_wait() cannot be used at the same time.
 * Use either or none of them but not both.
 *)

type
  libvlc_exit_callback_t = procedure(data: Pointer);
var
  libvlc_set_exit_handler : procedure (
    p_instance : libvlc_instance_t_ptr;
    cb         : libvlc_exit_callback_t;
    opaque     : Pointer
  ); cdecl;


(**
 * Waits until an interface causes the instance to exit.
 * You should start at least one interface first, using libvlc_add_intf().
 *
 * param p_instance the instance
 *)

var
  libvlc_wait : procedure(
    p_instance : libvlc_instance_t_ptr
  ); cdecl;

(**
 * Sets the application name. LibVLC passes this as the user agent string
 * when a protocol requires it.
 *
 * param p_instance LibVLC instance
 * param name human-readable application name, e.g. "FooBar player 1.2.3"
 * param http HTTP User Agent, e.g. "FooBar/1.2.3 Python/2.6.0"
 * version LibVLC 1.1.1 or later
 *)

var
  libvlc_set_user_agent : procedure(
    p_instance : libvlc_instance_t_ptr;
    name       : PAnsiChar;
    http       : PAnsiChar
  ); cdecl;

(**
 * Retrieve libvlc version.
 *
 * Example: "1.1.0-git The Luggage"
 *
 * @return a string containing the libvlc version
 *)

var
  libvlc_get_version : function() : PAnsiChar; cdecl;

(**
 * Retrieve libvlc compiler version.
 *
 * Example: "gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu6)"
 *
 * @return a string containing the libvlc compiler version
 *)

var
  libvlc_get_compiler : function() : PAnsiChar; cdecl;

(**
 * Retrieve libvlc changeset.
 *
 * Example: "aa9bce0bc4"
 *
 * @return a string containing the libvlc changeset
 *)

var
  libvlc_get_changeset : function() : PAnsiChar; cdecl;

(**
 * Frees an heap allocation returned by a LibVLC function.
 * If you know you're using the same underlying C run-time as the LibVLC
 * implementation, then you can call ANSI C free() directly instead.
 *
 * param ptr the pointer
 *)
var
  libvlc_free : procedure(
    ptr : Pointer
  ); cdecl;
 
(**
 * LibVLC emits asynchronous events.
 *
 * Several LibVLC objects (such @ref libvlc_instance_t as
 * @ref libvlc_media_player_t) generate events asynchronously. Each of them
 * provides @ref libvlc_event_manager_t event manager. You can subscribe to
 * events with libvlc_event_attach() and unsubscribe with
 * libvlc_event_detach().
 *
 * Event manager that belongs to a libvlc object, and from whom events can
 * be received.
 *)
    
(**
 * Register for an event notification.
 *
 * param p_event_manager the event manager to which you want to attach to.
 *       Generally it is obtained by vlc_my_object_event_manager() where
 *       my_object is the object you want to listen to.
 * param i_event_type the desired event to which we want to listen
 * param f_callback the function to call when i_event_type occurs
 * param user_data user provided data to carry with the event
 * @return 0 on success, ENOMEM on error
 *)

var
  libvlc_event_attach : function(
    p_event_manager : libvlc_event_manager_t_ptr;
    i_event_type    : libvlc_event_type_t;
    f_callback      : libvlc_event_callback_t;
    user_data       : Pointer
  ) : Integer; cdecl;
  
(**
 * Unregister an event notification.
 *
 * param p_event_manager the event manager
 * param i_event_type the desired event to which we want to unregister
 * param f_callback the function to call when i_event_type occurs
 * param p_user_data user provided data to carry with the event
 *)

var
  libvlc_event_detach : procedure(
    p_event_manager : libvlc_event_manager_t_ptr;
    i_event_type    : libvlc_event_type_t;
    f_callback      : libvlc_event_callback_t;
    p_user_data     : Pointer
  ); cdecl;

(**
 * Get an event's type name.
 *
 * param event_type the desired event
 *)

var
  libvlc_event_type_name : function(
    event_type : libvlc_event_type_t
  ) : PAnsiChar; cdecl;

(**
 * libvlc_log_* functions provide access to the LibVLC messages log.
 * This is used for debugging or by advanced users.
 *)

(**
 * Return the VLC messaging verbosity level.
 *
 * param p_instance libvlc instance
 * @return verbosity level for messages
 *)

var
  libvlc_get_log_verbosity : function(
    p_instance : libvlc_instance_t_ptr
  ) : LongWord; cdecl;

(**
 * Set the VLC messaging verbosity level.
 *
 * param p_instance libvlc instance
 * param level log level
 *)

var
  libvlc_set_log_verbosity : procedure(
    p_instance : libvlc_instance_t_ptr;
    level      : LongWord
  ); cdecl;
  
(**
 * Open a VLC message log instance.
 *
 * param p_instance libvlc instance
 * @return log message instance or NULL on error
 *)

var
  libvlc_log_open : function(
    p_instance : libvlc_instance_t_ptr
  ) : libvlc_log_t_ptr; cdecl;

(**
 * Close a VLC message log instance.
 *
 * param p_log libvlc log instance or NULL
 *)

var
  libvlc_log_close : procedure(
    p_log : libvlc_log_t_ptr
  ); cdecl;

(**
 * Returns the number of messages in a log instance.
 *
 * \param p_log libvlc log instance or NULL
 * @return number of log messages, 0 if p_log is NULL
 *)

var
  libvlc_log_count : function(
    p_log : libvlc_log_t_ptr
  ) : LongWord; cdecl;

(**
 * Clear a log instance.
 *
 * All messages in the log are removed. The log should be cleared on a
 * regular basis to avoid clogging.
 *
 * param p_log libvlc log instance or NULL
 *)

var
  libvlc_log_clear : procedure(
    p_log : libvlc_log_t_ptr
  ); cdecl;

(**
 * Allocate and returns a new iterator to messages in log.
 *
 * param p_log libvlc log instance
 * @return log iterator object or NULL on error
 *)

var
  libvlc_log_get_iterator : function(
    p_log: libvlc_log_t_ptr
  ) : libvlc_log_iterator_t_ptr; cdecl;

(**
 * Release a previoulsy allocated iterator.
 *
 * param p_iter libvlc log iterator or NULL
 *)

var
  libvlc_log_iterator_free : procedure(
    p_log : libvlc_log_t_ptr
  ); cdecl;

(**
 * Return whether log iterator has more messages.
 *
 * param p_iter libvlc log iterator or NULL
 * @return true if iterator has more message objects, else false
 *)

var
  libvlc_log_iterator_has_next : function(
    p_iter: libvlc_log_iterator_t_ptr
  ) : LongInt; cdecl;

(**
 * Return the next log message.
 *
 * The message contents must not be freed
 *
 * param p_iter libvlc log iterator or NULL
 * param p_buffer log buffer
 * @return log message object or NULL if none left
 *)

var
  libvlc_log_iterator_next : function(
    p_iter   : libvlc_log_iterator_t_ptr;
    p_buffer : libvlc_log_message_t_ptr
  ) : libvlc_log_message_t_ptr; cdecl;


(**
 * Description of a module.
 *)
type
  libvlc_module_description_t_ptr = ^libvlc_module_description_t;
  libvlc_module_description_t = packed record
    psz_name      : PAnsiChar;
    psz_shortname : PAnsiChar;
    psz_longname  : PAnsiChar;
    psz_help      : PAnsiChar;
    p_next        : libvlc_module_description_t_ptr;
  end;

(**
 * Release a list of module descriptions.
 *
 * param p_list the list to be released
 *)
var
  libvlc_module_description_list_release : procedure(
    p_list : libvlc_module_description_t_ptr
  ); cdecl;

(**
 * Returns a list of audio filters that are available.
 *
 * param p_instance libvlc instance
 *
 * return a list of module descriptions. It should be freed with libvlc_module_description_list_release().
 *         In case of an error, NULL is returned.
 *
 * see libvlc_module_description_t
 * see libvlc_module_description_list_release
 *)
var
  libvlc_audio_filter_list_get : function(
    p_instance  : libvlc_instance_t_ptr
  ) : libvlc_module_description_t_ptr; cdecl;

(**
 * Returns a list of video filters that are available.
 *
 * param p_instance libvlc instance
 *
 * return a list of module descriptions. It should be freed with libvlc_module_description_list_release().
 *         In case of an error, NULL is returned.
 *
 * see libvlc_module_description_t
 * see libvlc_module_description_list_release
 *)
var
  libvlc_video_filter_list_get : function(
    p_instance : libvlc_instance_t_ptr
  ) : libvlc_module_description_t_ptr; cdecl;

(**
 * Return the current time as defined by LibVLC. The unit is the microsecond.
 * Time increases monotonically (regardless of time zone changes and RTC
 * adjustements).
 * The origin is arbitrary but consistent across the whole system
 * (e.g. the system uptim, the time since the system was booted).
 * note On systems that support it, the POSIX monotonic clock is used.
 *)
var
  libvlc_clock : function() : Int64; cdecl;

(**
 * Return the delay (in microseconds) until a certain timestamp.
 * param pts timestamp
 * return negative if timestamp is in the past,
 * positive if it is in the future
 *)
function libvlc_delay(pts : Int64) : Int64; inline;

(*******************************************************************************
 * libvlc_media.h
 ******************************************************************************)

(**
 * Create a media with a certain given media resource location,
 * for instance a valid URL.
 *
 * To refer to a local file with this function,
 * the file://... URI syntax <b>must</b> be used (see IETF RFC3986).
 * We recommend using libvlc_media_new_path() instead when dealing with
 * local files.
 *
 * see libvlc_media_release
 *
 * param p_instance the instance
 * param psz_mrl the media location
 * @return the newly created media or NULL on error
 *)

var
  libvlc_media_new_location : function (
    p_instance : libvlc_instance_t_ptr;
    psz_mrl    : PAnsiChar
  ) : libvlc_media_t_ptr; cdecl;

(**
 * Create a media for a certain file path.
 *
 * see libvlc_media_release
 *
 * param p_instance the instance
 * param path local filesystem path
 * @return the newly created media or NULL on error
 *)

var
  libvlc_media_new_path : function(
    p_instance : libvlc_instance_t_ptr;
    path       : PAnsiChar
  ) : libvlc_media_t_ptr; cdecl;

(**
 * Create a media for an already open file descriptor.
 * The file descriptor shall be open for reading (or reading and writing).
 *
 * Regular file descriptors, pipe read descriptors and character device
 * descriptors (including TTYs) are supported on all platforms.
 * Block device descriptors are supported where available.
 * Directory descriptors are supported on systems that provide fdopendir().
 * Sockets are supported on all platforms where they are file descriptors,
 * i.e. all except Windows.
 *
 * This library will <b>not</b> automatically close the file descriptor
 * under any circumstance. Nevertheless, a file descriptor can usually only be
 * rendered once in a media player. To render it a second time, the file
 * descriptor should probably be rewound to the beginning with lseek().
 *
 * see libvlc_media_release
 *
 * version LibVLC 1.1.5 and later.
 *
 * param p_instance the instance
 * param fd open file descriptor
 * @return the newly created media or NULL on error
 *)
 
var
  libvlc_media_new_fd : function(
    p_instance : libvlc_instance_t_ptr;
    fd         : Integer
  ) : libvlc_media_t_ptr; cdecl;

(**
 * Create a media as an empty node with a given name.
 *
 * see libvlc_media_release
 *
 * param p_instance the instance
 * param psz_name the name of the node
 * @return the new empty media or NULL on error
 *)

var
  libvlc_media_new_as_node : function(
    p_instance : libvlc_instance_t_ptr;
    psz_name   : PAnsiChar
  ) : libvlc_media_t_ptr; cdecl;

(**
 * Add an option to the media.
 *
 * This option will be used to determine how the media_player will
 * read the media. This allows to use VLC's advanced
 * reading/streaming options on a per-media basis.
 *
 * The options are detailed in vlc --long-help, for instance "--sout-all"
 *
 * param p_md the media descriptor
 * param ppsz_options the options (as a string)
 *)

var
  libvlc_media_add_option : procedure(
    p_md         : libvlc_media_t_ptr;
    ppsz_options : PAnsiChar
  ); cdecl;

(**
 * Add an option to the media with configurable flags.
 *
 * This option will be used to determine how the media_player will
 * read the media. This allows to use VLC's advanced
 * reading/streaming options on a per-media basis.
 *
 * The options are detailed in vlc --long-help, for instance "--sout-all"
 *
 * param p_md the media descriptor
 * param ppsz_options the options (as a string)
 * param i_flags the flags for this option
 *)

var
  libvlc_media_add_option_flag : procedure(
    p_md         : libvlc_media_t_ptr;
    ppsz_options : PAnsiChar;
    i_flags      : input_item_option_e
  ); cdecl;

(**
 * Retain a reference to a media descriptor object (libvlc_media_t). Use
 * libvlc_media_release() to decrement the reference count of a
 * media descriptor object.
 *
 * param p_md the media descriptor
 *)

var
  libvlc_media_retain : procedure(
    p_md: libvlc_media_t_ptr
  ); cdecl;

(**
 * Decrement the reference count of a media descriptor object. If the
 * reference count is 0, then libvlc_media_release() will release the
 * media descriptor object. It will send out an libvlc_MediaFreed event
 * to all listeners. If the media descriptor object has been released it
 * should not be used again.
 *
 * param p_md the media descriptor
 *)

var
  libvlc_media_release : procedure(
    p_md : libvlc_media_t_ptr
  ); cdecl;


(**
 * Get the media resource locator (mrl) from a media descriptor object
 *
 * param p_md a media descriptor object
 * @return string with mrl of media descriptor object
 *)

var
  libvlc_media_get_mrl : function(
    p_md : libvlc_media_t_ptr
  ) : PAnsiChar; cdecl;

(**
 * Duplicate a media descriptor object.
 *
 * param p_md a media descriptor object.
 *)

var
  libvlc_media_duplicate : function (
    p_md : libvlc_media_t_ptr
  ) : libvlc_media_t_ptr; cdecl;

(**
 * Read the meta of the media.
 *
 * If the media has not yet been parsed this will return NULL.
 *
 * This methods automatically calls libvlc_media_parse_async(), so after calling
 * it you may receive a libvlc_MediaMetaChanged event. If you prefer a synchronous
 * version ensure that you call libvlc_media_parse() before get_meta().
 *
 * see libvlc_media_parse
 * see libvlc_media_parse_async
 * see libvlc_MediaMetaChanged
 *
 * param p_md the media descriptor
 * param e_meta the meta to read
 * @return the media's meta
 *)

var
  libvlc_media_get_meta : function(
    p_md   : libvlc_media_t_ptr;
    e_meta : libvlc_meta_t
  ) : PAnsiChar; cdecl;

(**
 * Set the meta of the media (this function will not save the meta, call
 * libvlc_media_save_meta in order to save the meta)
 *
 * param p_md the media descriptor
 * param e_meta the meta to write
 * param psz_value the media's meta
 *)

var
  libvlc_media_set_meta: procedure(
    p_md      : libvlc_media_t_ptr;
    e_meta    : libvlc_meta_t;
    psz_value : PAnsiChar
  ); cdecl;

(**
 * Save the meta previously set
 *
 * param p_md the media desriptor
 * @return true if the write operation was successfull
 *)

var
  libvlc_media_save_meta : function(
    p_md : libvlc_media_t_ptr
  ) : Integer; cdecl;

(**
 * Get current state of media descriptor object. Possible media states
 * are defined in libvlc_structures.c ( libvlc_NothingSpecial=0,
 * libvlc_Opening, libvlc_Buffering, libvlc_Playing, libvlc_Paused,
 * libvlc_Stopped, libvlc_Ended,
 * libvlc_Error).
 *
 * see libvlc_state_t
 * param p_meta_desc a media descriptor object
 * @return state of media descriptor object
 *)

var
  libvlc_media_get_state : function(
    p_md : libvlc_media_t_ptr
  ) : libvlc_state_t; cdecl;


(**
 * get the current statistics about the media
 * param p_md: media descriptor object
 * param p_stats: structure that contain the statistics about the media
 *                (this structure must be allocated by the caller)
 * @return true if the statistics are available, false otherwise
 *)

var
  libvlc_media_get_stats : function(
    p_md    : libvlc_media_t_ptr;
    p_stats : libvlc_media_stats_t_ptr
  ) : Integer; cdecl;

(**
 * Get subitems of media descriptor object. This will increment
 * the reference count of supplied media descriptor object. Use
 * libvlc_media_list_release() to decrement the reference counting.
 *
 * param p_md media descriptor object
 * @return list of media descriptor subitems or NULL
 *)

var
  libvlc_media_subitems : function(
    p_md : libvlc_media_t_ptr
  ) : libvlc_media_list_t_ptr; cdecl;

(**
 * Get event manager from media descriptor object.
 * NOTE: this function doesn't increment reference counting.
 *
 * param p_md a media descriptor object
 * @return event manager object
 *)

var
  libvlc_media_event_manager : function(
    p_md : libvlc_media_t_ptr
  ) : libvlc_event_manager_t_ptr; cdecl;

(**
 * Get duration (in ms) of media descriptor object item.
 *
 * param p_md media descriptor object
 * @return duration of media item or -1 on error
 *)

var
  libvlc_media_get_duration : function(
    p_md : libvlc_media_t_ptr
  ) : libvlc_time_t; cdecl;

(**
 * Parse a media.
 *
 * This fetches (local) meta data and tracks information.
 * The method is synchronous.
 *
 * see libvlc_media_parse_async
 * see libvlc_media_get_meta
 * see libvlc_media_get_tracks_info
 *
 * param media media descriptor object
 *)

var
  libvlc_media_parse : procedure(
    p_md : libvlc_media_t_ptr
  ); cdecl;

(**
 * Parse a media.
 *
 * This fetches (local) meta data and tracks information.
 * The method is the asynchronous of libvlc_media_parse().
 *
 * To track when this is over you can listen to libvlc_MediaParsedChanged
 * event. However if the media was already parsed you will not receive this
 * event.
 *
 * \see libvlc_media_parse
 * \see libvlc_MediaParsedChanged
 * \see libvlc_media_get_meta
 * \see libvlc_media_get_tracks_info
 *
 * \param media media descriptor object
 *)

var
  libvlc_media_parse_async : procedure(
    p_md : libvlc_media_t_ptr
  ); cdecl;

(**
 * Get Parsed status for media descriptor object.
 *
 * see libvlc_MediaParsedChanged
 *
 * param p_md media descriptor object
 * @return true if media object has been parsed otherwise it returns false
 *)

var
  libvlc_media_is_parsed : function(
    p_md : libvlc_media_t_ptr
  ) : Integer; cdecl;

(**
 * Sets media descriptor's user_data. user_data is specialized data
 * accessed by the host application, VLC.framework uses it as a pointer to
 * an native object that references a libvlc_media_t pointer
 *
 * param p_md media descriptor object
 * param p_new_user_data pointer to user data
 *)

var
  libvlc_media_set_user_data : procedure(
    p_md            : libvlc_media_t_ptr;
    p_new_user_data : Pointer
  ); cdecl;

(**
 * Get media descriptor's user_data. user_data is specialized data
 * accessed by the host application, VLC.framework uses it as a pointer to
 * an native object that references a libvlc_media_t pointer
 *
 * param p_md media descriptor object
 *)

var
  libvlc_media_get_user_data : function(
    p_md : libvlc_media_t_ptr
  ) : Pointer; cdecl;

(**
 * Get media descriptor's elementary streams description
 *
 * Note, you need to play the media _one_ time with --sout="#description"
 * Not doing this will result in an empty array, and doing it more than once
 * will duplicate the entries in the array each time. Something like this:
 *
 * libvlc_media_player_t *player = libvlc_media_player_new_from_media(media);
 * libvlc_media_add_option_flag(media, "sout=\"#description\"");
 * libvlc_media_player_play(player);
 * // ... wait until playing
 * libvlc_media_player_release(player);
 *
 * This is very likely to change in next release, and be done at the parsing
 * phase.
 *
 * param media media descriptor object
 * param tracks address to store an allocated array of Elementary Streams
 * descriptions (must be freed by the caller)
 *
 * @return the number of Elementary Streams
 *)

var
  libvlc_media_get_tracks_info : function(
    p_md       : libvlc_media_t_ptr;
    var tracks : libvlc_media_track_info_t_ptr
  ) : Integer; cdecl;

(*
 *******************************************************************************
 * libvlc_media_player.h
 *******************************************************************************
 *)

(**
 * Create an empty Media Player object
 *
 * param p_instance the libvlc instance in which the Media Player
 *        should be created.
 * @return a new media player object, or NULL on error.
 *)

var
  libvlc_media_player_new : function(
    p_instance : libvlc_instance_t_ptr
  ) : libvlc_media_player_t_ptr; cdecl;

(**
 * Create a Media Player object from a Media
 *
 * param p_md the media. Afterwards the p_md can be safely destroyed.
 * @return a new media player object, or NULL on error.
 *)

var
  libvlc_media_player_new_from_media : function(
    p_md : libvlc_media_t_ptr
  ) : libvlc_media_player_t_ptr; cdecl;

(**
 * Release a media_player after use
 * Decrement the reference count of a media player object. If the
 * reference count is 0, then libvlc_media_player_release() will
 * release the media player object. If the media player object
 * has been released, then it should not be used again.
 *
 * param p_mi the Media Player to free
 *)

var
  libvlc_media_player_release : procedure(
    p_mi : libvlc_media_player_t_ptr
  ); cdecl;

(**
 * Retain a reference to a media player object. Use
 * libvlc_media_player_release() to decrement reference count.
 *
 * param p_mi media player object
 *)

var
  libvlc_media_player_retain : procedure(
    p_mi : libvlc_media_player_t_ptr
  ); cdecl;

(**
 * Set the media that will be used by the media_player. If any,
 * previous md will be released.
 *
 * param p_mi the Media Player
 * param p_md the Media. Afterwards the p_md can be safely destroyed.
 *)

var
  libvlc_media_player_set_media : procedure(
    p_mi : libvlc_media_player_t_ptr;
    p_md : libvlc_media_t_ptr
  ); cdecl;

(**
 * Get the media used by the media_player.
 *
 * param p_mi the Media Player
 * @return the media associated with p_mi, or NULL if no media is associated
 *)
// VLC_PUBLIC_API libvlc_media_t * libvlc_media_player_get_media( libvlc_media_player_t *p_mi );
var
  libvlc_media_player_get_media : function(
    p_mi : libvlc_media_player_t_ptr
  ) : libvlc_media_t_ptr; cdecl;

(**
 * Get the Event Manager from which the media player send event.
 *
 * param p_mi the Media Player
 * @return the event manager associated with p_mi
 *)

var
  libvlc_media_player_event_manager : function(
    p_mi : libvlc_media_player_t_ptr
  ) : libvlc_event_manager_t_ptr; cdecl;

(**
 * is_playing
 *
 * param p_mi the Media Player
 * @return 1 if the media player is playing, 0 otherwise
 *)

var
  libvlc_media_player_is_playing : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Play
 *
 * param p_mi the Media Player
 * @return 0 if playback started (and was already started), or -1 on error.
 *)

var
  libvlc_media_player_play : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Pause or resume (no effect if there is no media)
 *
 * param mp the Media Player
 * param do_pause play/resume if zero, pause if non-zero
 * version LibVLC 1.1.1 or later
 *)
var
  libvlc_media_player_set_pause : procedure(
    p_mi     : libvlc_media_player_t_ptr;
    do_pause : Integer
  ); cdecl;

(**
 * Toggle pause (no effect if there is no media)
 *
 * param p_mi the Media Player
 *)

var
  libvlc_media_player_pause : procedure(
    p_mi : libvlc_media_player_t_ptr
  ); cdecl;

(**
 * Stop (no effect if there is no media)
 *
 * param p_mi the Media Player
 *)

var
  libvlc_media_player_stop : procedure(
    p_mi : libvlc_media_player_t_ptr
  ); cdecl;

(**
 * Callback prototype to configure picture buffers format.
 * This callback gets the format of the video as output by the video decoder
 * and the chain of video filters (if any). It can opt to change any parameter
 * as it needs. In that case, LibVLC will attempt to convert the video format
 * (rescaling and chroma conversion) but these operations can be CPU intensive.
 *
 * param opaque pointer to the private pointer passed to
 *               libvlc_video_set_callbacks() [IN/OUT]
 * param chroma pointer to the 4 bytes video format identifier [IN/OUT]
 * param width pointer to the pixel width [IN/OUT]
 * param height pointer to the pixel height [IN/OUT]
 * param pitches table of scanline pitches in bytes for each pixel plane
 *                (the table is allocated by LibVLC) [OUT]
 * param lines table of scanlines count for each plane [OUT]
 * return the number of picture buffers allocated, 0 indicates failure
 *
 * note
 * For each pixels plane, the scanline pitch must be bigger than or equal to
 * the number of bytes per pixel multiplied by the pixel width.
 * Similarly, the number of scanlines must be bigger than of equal to
 * the pixel height.
 * Furthermore, we recommend that pitches and lines be multiple of 32
 * to not break assumption that might be made by various optimizations
 * in the video decoders, video filters and/or video converters.
 *)
type
  libvlc_video_format_cb = procedure (
    var opaque : Pointer;
    chroma : PAnsiChar;
    var width, height : Integer;
    pitches : Pointer;
    lines : Pointer); cdecl;

(**
 * Callback prototype to configure picture buffers format.
 *
 * param opaque private pointer as passed to libvlc_video_set_callbacks()
 *               (and possibly modified by @ref libvlc_video_format_cb) [IN]
 *)
type
  libvlc_video_cleanup_cb = procedure(opaque : Pointer); cdecl;

type
  libvlc_video_lock_cb    = function(opaque : Pointer; var planes : Pointer) : Pointer; cdecl;
  libvlc_video_unlock_cb  = function(opaque : Pointer; picture : Pointer; planes : Pointer) : Pointer; cdecl;
  libvlc_video_display_cb = function(opaque : Pointer; picture : Pointer) : Pointer; cdecl;

(**
 * Set callbacks and private data to render decoded video to a custom area
 * in memory.
 * Use libvlc_video_set_format() or libvlc_video_set_format_callbacks()
 * to configure the decoded format.
 *
 * param mp the media player
 * param lock callback to lock video memory (must not be NULL)
 * param unlock callback to unlock video memory (or NULL if not needed)
 * param display callback to display video (or NULL if not needed)
 * param opaque private pointer for the three callbacks (as first parameter)
 * version LibVLC 1.1.1 or later
 *)
 
var
  libvlc_video_set_callbacks : procedure(
    p_mi    : libvlc_media_player_t_ptr;
    lock    : libvlc_video_lock_cb;
    unlock  : libvlc_video_unlock_cb;
    display : libvlc_video_display_cb;
    opaque  : Pointer
  ); cdecl;

(**
 * Set decoded video chroma and dimensions.
 * This only works in combination with libvlc_video_set_callbacks(),
 * and is mutually exclusive with libvlc_video_set_format_callbacks().
 *
 * param mp the media player
 * param chroma a four-characters string identifying the chroma
 *               (e.g. "RV32" or "YUYV")
 * param width pixel width
 * param height pixel height
 * param pitch line pitch (in bytes)
 * version LibVLC 1.1.1 or later
 * bug All pixel planes are expected to have the same pitch.
 * To use the YCbCr color space with chrominance subsampling,
 * consider using libvlc_video_set_format_callbacks() instead.
 *)

var
  libvlc_video_set_format : procedure(
    p_mi   : libvlc_media_player_t_ptr;
    chroma : PAnsiChar;
    width  : Longword;
    height : Longword;
    pitch  : Longword
  ); cdecl;

(**
 * Set decoded video chroma and dimensions. This only works in combination with
 * libvlc_video_set_callbacks().
 *
 * param mp the media player
 * param setup callback to select the video format (cannot be NULL)
 * param cleanup callback to release any allocated resources (or NULL)
 * version LibVLC 2.0.0 or later
 *)
var
  libvlc_video_set_format_callbacks : procedure(
    p_mi    : libvlc_media_player_t_ptr;
    setup   : libvlc_video_format_cb;
    cleanup : libvlc_video_cleanup_cb); cdecl;



(**
 * Set the NSView handler where the media player should render its video output.
 *
 * Use the vout called "macosx".
 *
 * The drawable is an NSObject that follow the VLCOpenGLVideoViewEmbedding
 * protocol:
 *)

 // \@protocol VLCOpenGLVideoViewEmbedding <NSObject>
 // - (void)addVoutSubview:(NSView *)view;
 // - (void)removeVoutSubview:(NSView *)view;
 // \@end

 (*
 * Or it can be an NSView object.
 *
 * If you want to use it along with Qt4 see the QMacCocoaViewContainer. Then
 * the following code should work:
 * @begincode
 * {
 *     NSView *video = [[NSView alloc] init];
 *     QMacCocoaViewContainer *container = new QMacCocoaViewContainer(video, parent);
 *     libvlc_media_player_set_nsobject(mp, video);
 *     [video release];
 * }
 * @endcode
 *
 * You can find a live example in VLCVideoView in VLCKit.framework.
 *
 * \param p_mi the Media Player
 * \param drawable the drawable that is either an NSView or an object following
 * the VLCOpenGLVideoViewEmbedding protocol.
 *)

var
  libvlc_media_player_set_nsobject : procedure(
    p_mi     : libvlc_media_player_t_ptr;
    drawable : Pointer
  ); cdecl;

(**
 * Get the NSView handler previously set with libvlc_media_player_set_nsobject().
 *
 * \param p_mi the Media Player
 * \return the NSView handler or 0 if none where set
 *)

var
  libvlc_media_player_get_nsobject : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Pointer; cdecl;

(**
 * Set the agl handler where the media player should render its video output.
 *
 * param p_mi the Media Player
 * param drawable the agl handler
 *)

var
  libvlc_media_player_set_agl : procedure(
    p_mi     : libvlc_media_player_t_ptr;
    drawable : LongWord
  ); cdecl;

(**
 * Get the agl handler previously set with libvlc_media_player_set_agl().
 *
 * param p_mi the Media Player
 * @return the agl handler or 0 if none where set
 *)

var
  libvlc_media_player_get_agl : function(
    p_mi : libvlc_media_player_t_ptr
  ) : LongWord; cdecl;

(**
 * Set an X Window System drawable where the media player should render its
 * video output. If LibVLC was built without X11 output support, then this has
 * no effects.
 *
 * The specified identifier must correspond to an existing Input/Output class
 * X11 window. Pixmaps are <b>not</b> supported. The caller shall ensure that
 * the X11 server is the same as the one the VLC instance has been configured
 * with.
 *
 * param p_mi the Media Player
 * param drawable the ID of the X window
 *)

var
  libvlc_media_player_set_xwindow : procedure(
    p_mi     : libvlc_media_player_t_ptr;
    drawable : LongWord
  ); cdecl;

(**
 * Get the X Window System window identifier previously set with
 * libvlc_media_player_set_xwindow(). Note that this will return the identifier
 * even if VLC is not currently using it (for instance if it is playing an
 * audio-only input).
 *
 * param p_mi the Media Player
 * @return an X window ID, or 0 if none where set.
 *)

var
  libvlc_media_player_get_xwindow : function(
    p_mi : libvlc_media_player_t_ptr
  ) : LongWord; cdecl;

(**
 * Set a Win32/Win64 API window handle (HWND) where the media player should
 * render its video output. If LibVLC was built without Win32/Win64 API output
 * support, then this has no effects.
 *
 * param p_mi the Media Player
 * param drawable windows handle of the drawable
 *)

var
  libvlc_media_player_set_hwnd : procedure(
    p_mi : libvlc_media_player_t_ptr;
    hwnd : THandle
  ); cdecl;

(**
 * Get the Windows API window handle (HWND) previously set with
 * libvlc_media_player_set_hwnd(). The handle will be returned even if LibVLC
 * is not currently outputting any video to it.
 *
 * \param p_mi the Media Player
 * \return a window handle or NULL if there are none.
 *)

var
  libvlc_media_player_get_hwnd : function(
    p_mi : libvlc_media_player_t_ptr
  ) : THandle; cdecl;


(**
 * Callback prototype for audio playback.
 * param data data pointer as passed to libvlc_audio_set_callbacks() [IN]
 * param samples pointer to the first audio sample to play back [IN]
 * param count number of audio samples to play back
 * param pts expected play time stamp (see libvlc_delay())
 *)
type
  libvlc_audio_play_cb = procedure(
    data : Pointer;
    const samples : Pointer;
    count : Cardinal;
    pts : Int64); cdecl;

(**
 * Callback prototype for audio pause.
 * note The pause callback is never called if the audio is already paused.
 * param data data pointer as passed to libvlc_audio_set_callbacks() [IN]
 * param pts time stamp of the pause request (should be elapsed already)
 *)
type
  libvlc_audio_pause_cb = procedure(
    data : Pointer;
    pts : Int64); cdecl;

(**
 * Callback prototype for audio resumption (i.e. restart from pause).
 * note The resume callback is never called if the audio is not paused.
 * param data data pointer as passed to libvlc_audio_set_callbacks() [IN]
 * param pts time stamp of the resumption request (should be elapsed already)
 *)
type
  libvlc_audio_resume_cb = procedure(
    data : Pointer;
    pts : Int64); cdecl;

(**
 * Callback prototype for audio buffer flush
 * (i.e. discard all pending buffers and stop playback as soon as possible).
 * param data data pointer as passed to libvlc_audio_set_callbacks() [IN]
 *)
type
  libvlc_audio_flush_cb = procedure(
    data : Pointer;
    pts : Int64); cdecl;

(**
 * Callback prototype for audio buffer drain
 * (i.e. wait for pending buffers to be played).
 * \param data data pointer as passed to libvlc_audio_set_callbacks() [IN]
 *)
type
  libvlc_audio_drain_cb = procedure(data : Pointer);

(**
 * Callback prototype for audio volume change.
 * param data data pointer as passed to libvlc_audio_set_callbacks() [IN]
 * param volume software volume (1. = nominal, 0. = mute)
 * param mute muted flag
 *)
type
  libvlc_audio_set_volume_cb = procedure(
    data : Pointer;
    volume : Single;
    mute : Boolean);

(**
 * Set callbacks and private data for decoded audio.
 * Use libvlc_audio_set_format() or libvlc_audio_set_format_callbacks()
 * to configure the decoded audio format.
 *
 * param mp the media player
 * param play callback to play audio samples (must not be NULL)
 * param pause callback to pause playback (or NULL to ignore)
 * param resume callback to resume playback (or NULL to ignore)
 * param flush callback to flush audio buffers (or NULL to ignore)
 * param drain callback to drain audio buffers (or NULL to ignore)
 * param opaque private pointer for the audio callbacks (as first parameter)
 * version LibVLC 2.0.0 or later
 *)
var
  libvlc_audio_set_callbacks : procedure(
    p_mi   : libvlc_media_player_t_ptr;
    play   : libvlc_audio_play_cb;
    pause  : libvlc_audio_pause_cb;
    resume : libvlc_audio_resume_cb;
    flush  : libvlc_audio_flush_cb;
    drain  : libvlc_audio_drain_cb;
    opaque : Pointer ); cdecl;

(**
 * Set callbacks and private data for decoded audio.
 * Use libvlc_audio_set_format() or libvlc_audio_set_format_callbacks()
 * to configure the decoded audio format.
 *
 * param mp the media player
 * param set_volume callback to apply audio volume,
 *                   or NULL to apply volume in software
 * version LibVLC 2.0.0 or later
 *)
var
  libvlc_audio_set_volume_callback : procedure(
    p_mi : libvlc_media_player_t_ptr;
    set_volume : libvlc_audio_set_volume_cb
  ); cdecl;

(**
 * Callback prototype to setup the audio playback.
 * This is called when the media player needs to create a new audio output.
 * param opaque pointer to the data pointer passed to
 *               libvlc_audio_set_callbacks() [IN/OUT]
 * param format 4 bytes sample format [IN/OUT]
 * param rate sample rate [IN/OUT]
 * param channels channels count [IN/OUT]
 * return 0 on success, anything else to skip audio playback
 *)
type
  libvlc_audio_setup_cb = function(
    var data : Pointer;
    format : PAnsiChar;
    rate  : Cardinal;
    channels : Cardinal) : Integer; cdecl;

(**
 * Callback prototype for audio playback cleanup.
 * This is called when the media player no longer needs an audio output.
 * param opaque data pointer as passed to libvlc_audio_set_callbacks() [IN]
 *)
type
  libvlc_audio_cleanup_cb = procedure(
    data : Pointer
  ); cdecl;

(**
 * Set decoded audio format. This only works in combination with
 * libvlc_audio_set_callbacks().
 *
 * param mp the media player
 * param setup callback to select the audio format (cannot be NULL)
 * param cleanup callback to release any allocated resources (or NULL)
 * version LibVLC 2.0.0 or later
 *)
var
  libvlc_audio_set_format_callbacks : procedure(
    p_mi    : libvlc_media_player_t_ptr;
    setup   : libvlc_audio_setup_cb;
    cleanup : libvlc_audio_cleanup_cb );

(**
 * Set decoded audio format.
 * This only works in combination with libvlc_audio_set_callbacks(),
 * and is mutually exclusive with libvlc_audio_set_format_callbacks().
 *
 * param mp the media player
 * param format a four-characters string identifying the sample format
 *               (e.g. "S16N" or "FL32")
 * param rate sample rate (expressed in Hz)
 * param channels channels count
 * version LibVLC 2.0.0 or later
 *)
var
  libvlc_audio_set_format : procedure(
     p_mp         : libvlc_media_player_t_ptr;
     const format : PAnsiChar;
     rate         : Cardinal;
     channels     : Cardinal);

(*
 *******************************************************************************
 * bug This might go away ... to be replaced by a broader system */
 *******************************************************************************
 *)

(**
 * Get the current movie length (in ms).
 *
 * param p_mi the Media Player
 * @return the movie length (in ms), or -1 if there is no media.
 *)

var
  libvlc_media_player_get_length : function(
    p_mi : libvlc_media_player_t_ptr
  ) : libvlc_time_t; cdecl;

(**
 * Get the current movie time (in ms).
 *
 * param p_mi the Media Player
 * @return the movie time (in ms), or -1 if there is no media.
 *)

var
  libvlc_media_player_get_time : function(
    p_mi : libvlc_media_player_t_ptr
  ) : libvlc_time_t; cdecl;

(**
 * Set the movie time (in ms). This has no effect if no media is being played.
 * Not all formats and protocols support this.
 *
 * param p_mi the Media Player
 * param i_time the movie time (in ms).
 *)

var
  libvlc_media_player_set_time : procedure(
    p_mi   : libvlc_media_player_t_ptr;
    i_time : libvlc_time_t
  ); cdecl;

(**
 * Get movie position.
 *
 * param p_mi the Media Player
 * @return movie position in range 0..1, or -1. in case of error
 *)

var
  libvlc_media_player_get_position : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Single; cdecl;

(**
 * Set movie position. This has no effect if playback is not enabled.
 * This might not work depending on the underlying input format and protocol.
 *
 * param p_mi the Media Player
 * param f_pos the position in range 0..1
 *)

var
  libvlc_media_player_set_position : procedure(
    p_mi  : libvlc_media_player_t_ptr;
    f_pos : Single // float
  ); cdecl;

(**
 * Set movie chapter (if applicable).
 *
 * param p_mi the Media Player
 * param i_chapter chapter number to play
 *)

var
  libvlc_media_player_set_chapter : procedure(
    p_mi      : libvlc_media_player_t_ptr;
    i_chapter : Integer
  ); cdecl;

(**
 * Get movie chapter.
 *
 * param p_mi the Media Player
 * @return chapter number currently playing, or -1 if there is no media.
 *)

var
  libvlc_media_player_get_chapter : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Get movie chapter count
 *
 * param p_mi the Media Player
 * @return number of chapters in movie, or -1.
 *)

var
  libvlc_media_player_get_chapter_count : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Is the player able to play
 *
 * param p_mi the Media Player
 * @return boolean
 *)

var
  libvlc_media_player_will_play : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Get title chapter count
 *
 * param p_mi the Media Player
 * param i_title title
 * @return number of chapters in title, or -1
 *)

var
  libvlc_media_player_get_chapter_count_for_title : function(
    p_mi    : libvlc_media_player_t_ptr;
    i_title : Integer
  ) : Integer; cdecl;

(**
 * Set movie title
 *
 * param p_mi the Media Player
 * param i_title title number to play
 *)

var
  libvlc_media_player_set_title : procedure(
    p_mi    : libvlc_media_player_t_ptr;
    i_title : Integer
  ); cdecl;

(**
 * Get movie title
 *
 * param p_mi the Media Player
 * @return title number currently playing, or -1
 *)

var
  libvlc_media_player_get_title : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Get movie title count
 *
 * param p_mi the Media Player
 * @return title number count, or -1
 *)

var
  libvlc_media_player_get_title_count : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Set previous chapter (if applicable)
 *
 * param p_mi the Media Player
 *)

var
  libvlc_media_player_previous_chapter : procedure(
    p_mi : libvlc_media_player_t_ptr
  ); cdecl;

(**
 * Set next chapter (if applicable)
 *
 * param p_mi the Media Player
 *)

var
  libvlc_media_player_next_chapter : procedure(
    p_mi : libvlc_media_player_t_ptr
  ); cdecl;

(**
 * Get the requested movie play rate.
 * @warning Depending on the underlying media, the requested rate may be
 * different from the real playback rate.
 *
 * param p_mi the Media Player
 * @return movie play rate
 *)

var
  libvlc_media_player_get_rate : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Single; cdecl;

(**
 * Set movie play rate
 *
 * param p_mi the Media Player
 * param rate movie play rate to set
 * @return -1 if an error was detected, 0 otherwise (but even then, it might
 * not actually work depending on the underlying media protocol)
 *)

var
  libvlc_media_player_set_rate : function(
    p_mi : libvlc_media_player_t_ptr;
    rate : Single // float
  ) : Integer; cdecl;

(**
 * Get current movie state
 *
 * param p_mi the Media Player
 * @return the current state of the media player (playing, paused, ...)
 * see libvlc_state_t
 *)

var
  libvlc_media_player_get_state : function(
    p_mi : libvlc_media_player_t_ptr
  ) : libvlc_state_t; cdecl;

(**
 * Get movie fps rate
 *
 * param p_mi the Media Player
 * @return frames per second (fps) for this playing movie, or 0 if unspecified
 *)

var
  libvlc_media_player_get_fps : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Single; cdecl;

(*
 *******************************************************************************
 * end bug
 *******************************************************************************
 *)

(**
 * How many video outputs does this media player have?
 *
 * param p_mi the media player
 * @return the number of video outputs
 *)

var
  libvlc_media_player_has_vout : function(
    p_mi : libvlc_media_player_t_ptr
  ) : LongWord; cdecl;

(**
 * Is this media player seekable?
 *
 * param p_mi the media player
 * @return true if the media player can seek
 *)

var
  libvlc_media_player_is_seekable : function(
    p_mi: libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Can this media player be paused?
 *
 * param p_mi the media player
 * @return true if the media player can pause
 *)

var
  libvlc_media_player_can_pause : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;


(**
 * Display the next frame (if supported)
 *
 * param p_mi the media player
 *)

var
  libvlc_media_player_next_frame : procedure(
    p_mi : libvlc_media_player_t_ptr
  ); cdecl;

(**
 * Navigate through DVD Menu
 *
 * param p_mi the Media Player
 * param navigate the Navigation mode
 * version libVLC 2.0.0 or later
 *)
var
  libvlc_media_player_navigate : procedure (
    p_mi     : libvlc_media_player_t_ptr;
    navigate : libvlc_navigate_mode_t ); cdecl;

(**
 * Release (free) libvlc_track_description_t
 *
 * param p_track_description the structure to release
 *)

var
  libvlc_track_description_release : procedure(
    p_track_description : libvlc_track_description_t_ptr
  ); cdecl;

(**
 * Toggle fullscreen status on non-embedded video outputs.
 *
 * @warning The same limitations applies to this function
 * as to libvlc_set_fullscreen().
 *
 * param p_mi the media player
 *)

var
  libvlc_toggle_fullscreen : procedure(
    p_mi : libvlc_media_player_t_ptr
  ); cdecl;

(**
 * Enable or disable fullscreen.
 *
 * @warning With most window managers, only a top-level windows can be in
 * full-screen mode. Hence, this function will not operate properly if
 * libvlc_media_player_set_xwindow() was used to embed the video in a
 * non-top-level window. In that case, the embedding window must be reparented
 * to the root window <b>before</b> fullscreen mode is enabled. You will want
 * to reparent it back to its normal parent when disabling fullscreen.
 *
 * param p_mi the media player
 * param b_fullscreen boolean for fullscreen status
 *)

var
  libvlc_set_fullscreen : procedure(
    p_mi         : libvlc_media_player_t_ptr;
    b_fullscreen : Integer
  ); cdecl;

(**
 * Get current fullscreen status.
 *
 * param p_mi the media player
 * @return the fullscreen status (boolean)
 *)

var
  libvlc_get_fullscreen : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Enable or disable key press events handling, according to the LibVLC hotkeys
 * configuration. By default and for historical reasons, keyboard events are
 * handled by the LibVLC video widget.
 *
 * On X11, there can be only one subscriber for key press and mouse
 * click events per window. If your application has subscribed to those events
 * for the X window ID of the video widget, then LibVLC will not be able to
 * handle key presses and mouse clicks in any case.
 *
 * This function is only implemented for X11 at the moment.
 *
 * param p_mi the media player
 * param on true to handle key press events, false to ignore them.
 *)

var
  libvlc_video_set_key_input : procedure(
    p_mi    : libvlc_media_player_t_ptr;
    keys_on : LongWord
  ); cdecl;

(**
 * Enable or disable mouse click events handling. By default, those events are
 * handled. This is needed for DVD menus to work, as well as a few video
 * filters such as "puzzle".
 *
 * See also libvlc_video_set_key_input().
 *
 * This function is only implemented for X11 at the moment.
 *
 * param p_mi the media player
 * param on true to handle mouse click events, false to ignore them.
 *)

var
  libvlc_video_set_mouse_input: procedure(
    p_mi     : libvlc_media_player_t_ptr;
    mouse_on : LongWord
  ); cdecl;


(**
 * Get the pixel dimensions of a video.
 *
 * param p_mi media player
 * param num number of the video (starting from, and most commonly 0)
 * param px pointer to get the pixel width [OUT]
 * param py pointer to get the pixel height [OUT]
 * @return 0 on success, -1 if the specified video does not exist
 *)

var
  libvlc_video_get_size : function(
    p_mi : libvlc_media_player_t_ptr;
    num  : LongWord;
    var px, py: LongWord
  ) : Integer; cdecl;

{$IFDEF USE_VLC_DEPRECATED_API}
(**
 * Get current video height.
 * You should use libvlc_video_get_size() instead.
 *
 * param p_mi the media player
 * @return the video pixel height or 0 if not applicable
 *)

var
  libvlc_video_get_height : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;
{$ENDIF}

{$IFDEF USE_VLC_DEPRECATED_API}
(**
 * Get current video width.
 * You should use libvlc_video_get_size() instead.
 *
 * param p_mi the media player
 * @return the video pixel width or 0 if not applicable
 *)

var
  libvlc_video_get_width : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;
{$ENDIF}

(**
 * Get the mouse pointer coordinates over a video.
 * Coordinates are expressed in terms of the decoded video resolution,
 * <b>not</b> in terms of pixels on the screen/viewport (to get the latter,
 * you can query your windowing system directly).
 *
 * Either of the coordinates may be negative or larger than the corresponding
 * dimension of the video, if the cursor is outside the rendering area.
 *
 * @warning The coordinates may be out-of-date if the pointer is not located
 * on the video rendering area. LibVLC does not track the pointer if it is
 * outside of the video widget.
 *
 * @note LibVLC does not support multiple pointers (it does of course support
 * multiple input devices sharing the same pointer) at the moment.
 *
 * param p_mi media player
 * param num number of the video (starting from, and most commonly 0)
 * param px pointer to get the abscissa [OUT]
 * param py pointer to get the ordinate [OUT]
 * @return 0 on success, -1 if the specified video does not exist
 *)

var
  libvlc_video_get_cursor : function(
    p_mi : libvlc_media_player_t_ptr;
    num  :  LongWord;
    var px, py : Integer
  ) : Integer; cdecl;

(**
 * Get the current video scaling factor.
 * See also libvlc_video_set_scale().
 *
 * param p_mi the media player
 * @return the currently configured zoom factor, or 0. if the video is set
 * to fit to the output window/drawable automatically.
 *)

var
  libvlc_video_get_scale : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Single; cdecl;

(**
 * Set the video scaling factor. That is the ratio of the number of pixels on
 * screen to the number of pixels in the original decoded video in each
 * dimension. Zero is a special value; it will adjust the video to the output
 * window/drawable (in windowed mode) or the entire screen.
 *
 * Note that not all video outputs support scaling.
 *
 * param p_mi the media player
 * param f_factor the scaling factor, or zero
 *)

var
  libvlc_video_set_scale : procedure(
    p_mi     : libvlc_media_player_t_ptr;
    f_factor : Single // float
  ); cdecl;

(**
 * Get current video aspect ratio.
 *
 * param p_mi the media player
 * @return the video aspect ratio or NULL if unspecified
 * (the result must be released with free() or libvlc_free()).
 *)

var
  libvlc_video_get_aspect_ratio : function(
    p_mi : libvlc_media_player_t_ptr
  ) : PAnsiChar; cdecl;

(**
 * Set new video aspect ratio.
 *
 * param p_mi the media player
 * param psz_aspect new video aspect-ratio or NULL to reset to default
 * Invalid aspect ratios are ignored.
 *)

var
  libvlc_video_set_aspect_ratio : procedure(
    p_mi       : libvlc_media_player_t_ptr;
    psz_aspect : PAnsiChar
  ); cdecl;

(**
 * Get current video subtitle.
 *
 * param p_mi the media player
 * @return the video subtitle selected, or -1 if none
 *)

var
  libvlc_video_get_spu : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Get the number of available video subtitles.
 *
 * param p_mi the media player
 * @return the number of available video subtitles
 *)

var
  libvlc_video_get_spu_count : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Get the description of available video subtitles.
 *
 * param p_mi the media player
 * @return list containing description of available video subtitles
 *)

var
  libvlc_video_get_spu_description : function(
    p_mi : libvlc_media_player_t_ptr
  ) : libvlc_track_description_t_ptr; cdecl;

(**
 * Set new video subtitle.
 *
 * param p_mi the media player
 * param i_spu new video subtitle to select
 * @return 0 on success, -1 if out of range
 *)

var
  libvlc_video_set_spu : function(
    p_mi  : libvlc_media_player_t_ptr;
    i_spu : LongWord
  ) : Integer; cdecl;

(**
 * Set new video subtitle file.
 *
 * param p_mi the media player
 * param psz_subtitle new video subtitle file
 * @return the success status (boolean)
 *)

var
  libvlc_video_set_subtitle_file : function(
    p_mi         : libvlc_media_player_t_ptr;
    psz_subtitle : PAnsiChar
  ) : Integer; cdecl;

(**
 * Get the current subtitle delay. Positive values means subtitles are being
 * displayed later, negative values earlier.
 *
 * param p_mi media player
 * return time (in microseconds) the display of subtitles is being delayed
 * version LibVLC 2.0.0 or later
 *)
var
 libvlc_video_get_spu_delay : function(
   p_mi : libvlc_media_player_t_ptr
 ): Int64; cdecl;

(**
 * Set the subtitle delay. This affects the timing of when the subtitle will
 * be displayed. Positive values result in subtitles being displayed later,
 * while negative values will result in subtitles being displayed earlier.
 *
 * The subtitle delay will be reset to zero each time the media changes.
 *
 * param p_mi media player
 * param i_delay time (in microseconds) the display of subtitles should be delayed
 * return 0 on success, -1 on error
 * version LibVLC 2.0.0 or later
 *)
var
  libvlc_video_set_spu_delay : function (
    p_mi : libvlc_media_player_t_ptr;
    i_delay : Int64
  ) : Integer; cdecl;


(**
 * Get the description of available titles.
 *
 * param p_mi the media player
 * @return list containing description of available titles
 *)

var
  libvlc_video_get_title_description : function(
    p_mi : libvlc_media_player_t_ptr
  ) : libvlc_track_description_t_ptr; cdecl;

(**
 * Get the description of available chapters for specific title.
 *
 * param p_mi the media player
 * param i_title selected title
 * @return list containing description of available chapter for title i_title
 *)

var
  libvlc_video_get_chapter_description : function(
    p_mi    : libvlc_media_player_t_ptr;
    i_title : Integer
  ) : libvlc_track_description_t_ptr; cdecl;

(**
 * Get current crop filter geometry.
 *
 * param p_mi the media player
 * @return the crop filter geometry or NULL if unset
 *)

var
  libvlc_video_get_crop_geometry : function(
    p_mi : libvlc_media_player_t_ptr
  ) : PAnsiChar; cdecl;

(**
 * Set new crop filter geometry.
 *
 * param p_mi the media player
 * param psz_geometry new crop filter geometry (NULL to unset)
 *)

var
  libvlc_video_set_crop_geometry : procedure(
    p_mi         : libvlc_media_player_t_ptr;
    psz_geometry : PAnsiChar
  ); cdecl;

(**
 * Get current teletext page requested.
 *
 * param p_mi the media player
 * @return the current teletext page requested.
 *)

var
  libvlc_video_get_teletext : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Set new teletext page to retrieve.
 *
 * param p_mi the media player
 * param i_page teletex page number requested
 *)

var
  libvlc_video_set_teletext : procedure(
    p_mi   : libvlc_media_player_t_ptr;
    i_page : Integer
  ); cdecl;

(**
 * Toggle teletext transparent status on video output.
 *
 * param p_mi the media player
 *)

var
  libvlc_toggle_teletext : procedure(
    p_mi : libvlc_media_player_t_ptr
  ); cdecl;

(**
 * Get number of available video tracks.
 *
 * param p_mi media player
 * @return the number of available video tracks (int)
 *)

var
  libvlc_video_get_track_count : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Get the description of available video tracks.
 *
 * param p_mi media player
 * @return list with description of available video tracks, or NULL on error
 *)

var
  libvlc_video_get_track_description : function(
    p_mi : libvlc_media_player_t_ptr
  ) : libvlc_track_description_t_ptr; cdecl;

(**
 * Get current video track.
 *
 * param p_mi media player
 * @return the video track (int) or -1 if none
 *)

var
  libvlc_video_get_track : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Set video track.
 *
 * param p_mi media player
 * param i_track the track (int)
 * @return 0 on success, -1 if out of range
 *)

var
  libvlc_video_set_track : function(
    p_mi    : libvlc_media_player_t_ptr;
    i_track : Integer
  ) : Integer; cdecl;

(**
 * Take a snapshot of the current video window.
 *
 * If i_width AND i_height is 0, original size is used.
 * If i_width XOR i_height is 0, original aspect-ratio is preserved.
 *
 * param p_mi media player instance
 * param num number of video output (typically 0 for the first/only one)
 * param psz_filepath the path where to save the screenshot to
 * param i_width the snapshot's width
 * param i_height the snapshot's height
 * @return 0 on success, -1 if the video was not found
 *)

var
  libvlc_video_take_snapshot : function(
    p_mi         : libvlc_media_player_t_ptr;
    num          : Integer;
    psz_filepath : PAnsiChar;
    i_width      : LongWord;
    i_height     : LongWord
  ) : Integer; cdecl;

(**
 * Enable or disable deinterlace filter
 *
 * param p_mi libvlc media player
 * param psz_mode type of deinterlace filter, NULL to disable
 *)

var
  libvlc_video_set_deinterlace : procedure(
    p_mi     : libvlc_media_player_t_ptr;
    psz_mode : PAnsiChar
  ); cdecl;

(**
 * Get an integer marquee option value
 *
 * param p_mi libvlc media player
 * param option marq option to get \see libvlc_video_marquee_int_option_t
 *)

var
  libvlc_video_get_marquee_int : function(
    p_mi   : libvlc_media_player_t_ptr;
    option : libvlc_video_marquee_option_t
  ) : Integer; cdecl;

(**
 * Get a string marquee option value
 *
 * param p_mi libvlc media player
 * param option marq option to get
 *)

var
  libvlc_video_get_marquee_string : function(
    p_mi   : libvlc_media_player_t_ptr;
    option : libvlc_video_marquee_option_t
  ) : PAnsiChar; cdecl;

(**
 * Enable, disable or set an integer marquee option
 *
 * Setting libvlc_marquee_Enable has the side effect of enabling (arg !0)
 * or disabling (arg 0) the marq filter.
 *
 * param p_mi libvlc media player
 * param option marq option to set
 * param i_val marq option value
 *)

var
  libvlc_video_set_marquee_int : procedure(
    p_mi   : libvlc_media_player_t_ptr;
    option : libvlc_video_marquee_option_t;
    i_val  : Integer
  ); cdecl;

(**
 * Set a marquee string option
 *
 * param p_mi libvlc media player
 * param option marq option to set \see libvlc_video_marquee_string_option_t
 * param psz_text marq option value
 *)

var
  libvlc_video_set_marquee_string : procedure(
    p_mi     : libvlc_media_player_t_ptr;
    option   : libvlc_video_marquee_option_t;
    psz_text : PAnsiChar
  ); cdecl;

(**
 * Get integer logo option.
 *
 * param p_mi libvlc media player instance
 * param option logo option to get, values of libvlc_video_logo_option_t
 *)

var
  libvlc_video_get_logo_int : function(
    p_mi   : libvlc_media_player_t_ptr;
    option : LongWord
  ) : Integer; cdecl;

(**
 * Set logo option as integer. Options that take a different type value
 * are ignored.
 * Passing libvlc_logo_enable as option value has the side effect of
 * starting (arg !0) or stopping (arg 0) the logo filter.
 *
 * param p_mi libvlc media player instance
 * param option logo option to set, values of libvlc_video_logo_option_t
 * param value logo option value
 *)

var
  libvlc_video_set_logo_int : procedure(
    p_mi   : libvlc_media_player_t_ptr;
    option : LongWord;
    value  : Integer
  ); cdecl;

(**
 * Set logo option as string. Options that take a different type value
 * are ignored.
 *
 * param p_mi libvlc media player instance
 * param option logo option to set, values of libvlc_video_logo_option_t
 * param psz_value logo option value
 *)

var
  libvlc_video_set_logo_string : procedure(
    p_mi      : libvlc_media_player_t_ptr;
    option    : LongWord;
    psz_value : PAnsiChar
  ); cdecl;

(** option values for libvlc_video_{get,set}_adjust_{int,float,bool} *)
type
  libvlc_video_adjust_option_t = (
    libvlc_adjust_Enable = 0,
    libvlc_adjust_Contrast,
    libvlc_adjust_Brightness,
    libvlc_adjust_Hue,
    libvlc_adjust_Saturation,
    libvlc_adjust_Gamma
  );

(**
 * Get integer adjust option.
 *
 * param p_mi libvlc media player instance
 * param option adjust option to get, values of libvlc_video_adjust_option_t
 * version LibVLC 1.1.1 and later.
 *)
var
  libvlc_video_get_adjust_int : function(
    p_mi   : libvlc_media_player_t_ptr;
    option : LongWord
  ) : Integer; cdecl;

(**
 * Set adjust option as integer. Options that take a different type value
 * are ignored.
 * Passing libvlc_adjust_enable as option value has the side effect of
 * starting (arg !0) or stopping (arg 0) the adjust filter.
 *
 * param p_mi libvlc media player instance
 * param option adust option to set, values of libvlc_video_adjust_option_t
 * param value adjust option value
 * version LibVLC 1.1.1 and later.
 *)
var
  libvlc_video_set_adjust_int : procedure(
    p_mi   : libvlc_media_player_t_ptr;
    option : LongWord;
    value  : Integer
  ); cdecl;

(**
 * Get float adjust option.
 *
 * param p_mi libvlc media player instance
 * param option adjust option to get, values of libvlc_video_adjust_option_t
 * version LibVLC 1.1.1 and later.
 *)
var
  libvlc_video_get_adjust_float : function(
    p_mi   : libvlc_media_player_t_ptr;
    option : LongWord
  ) : Single; cdecl;

(**
 * Set adjust option as float. Options that take a different type value
 * are ignored.
 *
 * param p_mi libvlc media player instance
 * param option adust option to set, values of libvlc_video_adjust_option_t
 * param value adjust option value
 * version LibVLC 1.1.1 and later.
 *)
var
  libvlc_video_set_adjust_float : procedure(
    p_mi   : libvlc_media_player_t_ptr;
    option : LongWord;
    value  : Single
  ); cdecl;

(**
 * Get the list of available audio outputs
 *
 * param p_instance libvlc instance
 * @return list of available audio outputs. It must be freed it with
 * see libvlc_audio_output_list_release see libvlc_audio_output_t .
 * In case of error, NULL is returned.
 *)

var
  libvlc_audio_output_list_get : function(
    p_instance : libvlc_instance_t_ptr
  ) : libvlc_audio_output_t_ptr; cdecl;

(**
 * Free the list of available audio outputs
 *
 * param p_list list with audio outputs for release
 *)

var
  libvlc_audio_output_list_release : procedure(
    p_list : libvlc_audio_output_t_ptr
  ); cdecl;

(**
 * Set the audio output.
 * Change will be applied after stop and play.
 *
 * param p_mi media player
 * param psz_name name of audio output,
 * use psz_name of \see libvlc_audio_output_t
 * \return 0 if function succeded, -1 on error
 *)

var
  libvlc_audio_output_set : function(
    p_mi     : libvlc_media_player_t_ptr;
    psz_name : PAnsiChar
  ) : Integer; cdecl;

(**
 * Get count of devices for audio output, these devices are hardware oriented
 * like analor or digital output of sound card
 *
 * param p_instance libvlc instance
 * param psz_audio_output - name of audio output, \see libvlc_audio_output_t
 * @return number of devices
 *)

var
  libvlc_audio_output_device_count : function(
    p_instance       : libvlc_instance_t_ptr;
    psz_audio_output : PAnsiChar
  ) : Integer; cdecl;

(**
 * Get long name of device, if not available short name given
 *
 * param p_instance libvlc instance
 * param psz_audio_output - name of audio output, \see libvlc_audio_output_t
 * param i_device device index
 * @return long name of device
 *)

var
  libvlc_audio_output_device_longname : function(
    p_instance       : libvlc_instance_t_ptr;
    psz_audio_output : PAnsiChar;
    i_device         : Integer
  ) : PAnsiChar; cdecl;

(**
 * Get id name of device
 *
 * param p_instance libvlc instance
 * param psz_audio_output - name of audio output, \see libvlc_audio_output_t
 * param i_device device index
 * @return id name of device, use for setting device, need to be free after use
 *)

var
  libvlc_audio_output_device_id : function(
    p_instance       : libvlc_instance_t_ptr;
    psz_audio_output : PAnsiChar;
    i_device         : Integer
  ) : PAnsiChar; cdecl;

(**
 * Set audio output device. Changes are only effective after stop and play.
 *
 * param p_mi media player
 * param psz_audio_output - name of audio output, see libvlc_audio_output_t
 * param psz_device_id device
 *)

var
  libvlc_audio_output_device_set : procedure(
    p_mi             : libvlc_media_player_t_ptr;
    psz_audio_output : PAnsiChar;
    psz_device_id    : PAnsiChar
  ); cdecl;

(**
 * Get current audio device type. Device type describes something like
 * character of output sound - stereo sound, 2.1, 5.1 etc
 *
 * param p_mi media player
 * @return the audio devices type see libvlc_audio_output_device_types_t
 *)

var
  libvlc_audio_output_get_device_type : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Set current audio device type.
 *
 * param p_mi vlc instance
 * param device_type the audio device type,
          according to see libvlc_audio_output_device_types_t
 *)

var
  libvlc_audio_output_set_device_type : procedure(
    p_mi        : libvlc_media_player_t_ptr;
    device_type : Integer
  ); cdecl;

(**
 * Toggle mute status.
 *
 * param p_mi media player
 *)

var
  libvlc_audio_toggle_mute : procedure(
    p_mi : libvlc_media_player_t_ptr
  ); cdecl;

(**
 * Get current mute status.
 *
 * param p_mi media player
 * @return the mute status (boolean)
 *)

var
  libvlc_audio_get_mute : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Set mute status.
 *
 * param p_mi media player
 * param status If status is true then mute, otherwise unmute
 *)

var
  libvlc_audio_set_mute : procedure(
    p_mi   : libvlc_media_player_t_ptr;
    status : Integer
  ); cdecl;

(**
 * Get current software audio volume.
 *
 * param p_mi media player
 * return the software volume in percents
 * (0 = mute, 100 = nominal / 0dB)
 *)

var
  libvlc_audio_get_volume : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Set current software audio volume.
 *
 * param p_mi media player
 * param i_volume the volume in percents (0 = mute, 100 = 0dB)
 * return 0 if the volume was set, -1 if it was out of range
 *)

var
  libvlc_audio_set_volume : function(
    p_mi     : libvlc_media_player_t_ptr;
    i_volume : Integer
  ) : Integer; cdecl;

(**
 * Get number of available audio tracks.
 *
 * param p_mi media player
 * @return the number of available audio tracks (int), or -1 if unavailable
 *)

var
  libvlc_audio_get_track_count : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Get the description of available audio tracks.
 *
 * param p_mi media player
 * @return list with description of available audio tracks, or NULL
 *)

var
  libvlc_audio_get_track_description : function(
    p_mi : libvlc_media_player_t_ptr
  ) : libvlc_track_description_t_ptr; cdecl;

(**
 * Get current audio track.
 *
 * param p_mi media player
 * @return the audio track (int), or -1 if none.
 *)

var
  libvlc_audio_get_track : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Set current audio track.
 *
 * param p_mi media player
 * param i_track the track (int)
 * @return 0 on success, -1 on error
 *)

var
  libvlc_audio_set_track : function(
    p_mi    : libvlc_media_player_t_ptr;
    i_track : Integer
  ) : Integer; cdecl;

(**
 * Get current audio channel.
 *
 * param p_mi media player
 * @return the audio channel \see libvlc_audio_output_channel_t
 *)

var
  libvlc_audio_get_channel : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Integer; cdecl;

(**
 * Set current audio channel.
 *
 * param p_mi media player
 * param channel the audio channel, \see libvlc_audio_output_channel_t
 * @return 0 on success, -1 on error
 *)

var
  libvlc_audio_set_channel : function(
    p_mi      : libvlc_media_player_t_ptr;
    i_channel : Integer
  ) : Integer; cdecl;

(**
 * Get current audio delay.
 *
 * param p_mi media player
 * return the audio delay (microseconds)
 * version LibVLC 1.1.1 or later
 *)
var
  libvlc_audio_get_delay : function(
    p_mi : libvlc_media_player_t_ptr
  ) : Int64; cdecl;

(**
 * Set current audio delay. The audio delay will be reset to zero each time the media changes.
 *
 * param p_mi media player
 * param i_delay the audio delay (microseconds)
 * return 0 on success, -1 on error
 * version LibVLC 1.1.1 or later
 *)
var
  libvlc_audio_set_delay : function(
    p_mi    : libvlc_media_player_t_ptr;
    i_delay : Int64
  ) : Integer; cdecl;

(*
 *******************************************************************************
 * libvlc_media_list.h
 *******************************************************************************
 *)

(**
 * Create an empty media list.
 *
 * param p_instance libvlc instance
 * @return empty media list, or NULL on error
 *)

var
  libvlc_media_list_new : function(
    p_instance : libvlc_instance_t_ptr
  ) : libvlc_media_list_t_ptr; cdecl;

(**
 * Release media list created with libvlc_media_list_new().
 *
 * param p_ml a media list created with libvlc_media_list_new()
 *)

var
  libvlc_media_list_release : procedure(
    p_ml : libvlc_media_list_t_ptr
  ); cdecl;

(**
 * Retain reference to a media list
 *
 * param p_ml a media list created with libvlc_media_list_new()
 *)

var
  libvlc_media_list_retain : procedure(
    p_ml : libvlc_media_list_t_ptr
  ); cdecl;

{$IFDEF USE_VLC_DEPRECATED_API}
var
  libvlc_media_list_add_file_content:  function(
    p_ml    : libvlc_media_list_t_ptr;
    psz_uri : PAnsiChar
  ) : Integer; cdecl;
{$ENDIF}

(**
 * Associate media instance with this media list instance.
 * If another media instance was present it will be released.
 * The libvlc_media_list_lock should NOT be held upon entering this function.
 *
 * param p_ml a media list instance
 * param p_md media instance to add
 *)

var
  libvlc_media_list_set_media : procedure(
    p_ml : libvlc_media_list_t_ptr;
    p_md : libvlc_media_t_ptr
  ); cdecl;

(**
 * Get media instance from this media list instance. This action will increase
 * the refcount on the media instance.
 * The libvlc_media_list_lock should NOT be held upon entering this function.
 *
 * param p_ml a media list instance
 * return media instance
 *)

var
  libvlc_media_list_media : function(
    p_ml : libvlc_media_list_t_ptr
  ) : libvlc_media_t_ptr; cdecl;

(**
 * Add media instance to media list
 * The libvlc_media_list_lock should be held upon entering this function.
 *
 * param p_ml a media list instance
 * param p_md a media instance
 * @return 0 on success, -1 if the media list is read-only
 *)

var
  libvlc_media_list_add_media : function(
    p_ml : libvlc_media_list_t_ptr;
    p_md : libvlc_media_t_ptr
  ) : Integer; cdecl;

(**
 * Insert media instance in media list on a position
 * The libvlc_media_list_lock should be held upon entering this function.
 *
 * param p_ml a media list instance
 * param p_md a media instance
 * param i_pos position in array where to insert
 * @return 0 on success, -1 if the media list si read-only
 *)

var
  libvlc_media_list_insert_media : function(
    p_ml  : libvlc_media_list_t_ptr;
    p_md  : libvlc_media_t_ptr;
    i_pos : Integer
  ) : Integer; cdecl;

(**
 * Remove media instance from media list on a position
 * The libvlc_media_list_lock should be held upon entering this function.
 *
 * param p_ml a media list instance
 * param i_pos position in array where to insert
 * @return 0 on success, -1 if the list is read-only or the item was not found
 *)

var
  libvlc_media_list_remove_index : function(
    p_ml  : libvlc_media_list_t_ptr;
    i_pos : Integer
  ) : Integer; cdecl;

(**
 * Get count on media list items
 * The libvlc_media_list_lock should be held upon entering this function.
 *
 * param p_ml a media list instance
 * @return number of items in media list
 *)

var
  libvlc_media_list_count : function(
    p_ml : libvlc_media_list_t_ptr
  ) : Integer; cdecl;

(**
 * List media instance in media list at a position
 * The libvlc_media_list_lock should be held upon entering this function.
 *
 * param p_ml a media list instance
 * param i_pos position in array where to insert
 * @return media instance at position i_pos, or -1 if not found.
 * In case of success, libvlc_media_retain() is called to increase the refcount
 * on the media.
 *)

var
  libvlc_media_list_item_at_index : function(
    p_ml  : libvlc_media_list_t_ptr;
    i_pos : Integer
  ) : libvlc_media_t_ptr; cdecl;

(**
 * Find index position of List media instance in media list.
 * Warning: the function will return the first matched position.
 * The libvlc_media_list_lock should be held upon entering this function.
 *
 * param p_ml a media list instance
 * param p_md media list instance
 * @return position of media instance
 *)

var
  libvlc_media_list_index_of_item : function(
    p_ml : libvlc_media_list_t_ptr;
    p_md : libvlc_media_t_ptr
  ) : Integer; cdecl;

(**
 * This indicates if this media list is read-only from a user point of view
 *
 * param p_ml media list instance
 * @return 1 on readonly, 0 on readwrite
 *)

var
  libvlc_media_list_is_readonly : function(
    p_ml : libvlc_media_list_t_ptr
  ) : Integer; cdecl;

(**
 * Get lock on media list items
 *
 * param p_ml a media list instance
 *)

var
  libvlc_media_list_lock : procedure(
    p_ml : libvlc_media_list_t_ptr
  ); cdecl;

(**
 * Release lock on media list items
 * The libvlc_media_list_lock should be held upon entering this function.
 *
 * param p_ml a media list instance
 *)

var
  libvlc_media_list_unlock : procedure(
    p_ml : libvlc_media_list_t_ptr
  ); cdecl;

(**
 * Get libvlc_event_manager from this media list instance.
 * The p_event_manager is immutable, so you don't have to hold the lock
 *
 * param p_ml a media list instance
 * @return libvlc_event_manager
 *)

var
  libvlc_media_list_event_manager : function(
    p_ml : libvlc_media_list_t_ptr
  ) : libvlc_event_manager_t_ptr; cdecl;

(*******************************************************************************
 * libvlc_media_list_player.h
 *******************************************************************************
 *)

(**
 * The LibVLC media list player plays a @ref libvlc_media_list_t list of media,
 * in a certain order.
 * This is required to especially support playlist files.
 * The normal @ref libvlc_media_player_t LibVLC media player can only play a
 * single media, and does not handle playlist files properly.
 *)

(**
 * Create new media_list_player.
 *
 * param p_instance libvlc instance
 * @return media list player instance or NULL on error
 *)

var
  libvlc_media_list_player_new : function(
    p_instance : libvlc_instance_t_ptr
  ) : libvlc_media_list_player_t_ptr; cdecl;

(**
 * Release a media_list_player after use
 * Decrement the reference count of a media player object. If the
 * reference count is 0, then libvlc_media_list_player_release() will
 * release the media player object. If the media player object
 * has been released, then it should not be used again.
 *
 * param p_mlp media list player instance
 *)

var
  libvlc_media_list_player_release : procedure(
    p_mlp : libvlc_media_list_player_t_ptr
  ); cdecl;

(**
 * Retain a reference to a media player list object. Use
 * libvlc_media_list_player_release() to decrement reference count.
 *
 * param p_mlp media player list object
 *)
var
  libvlc_media_list_player_retain : procedure(
    p_mlp : libvlc_media_list_player_t_ptr
  ); cdecl;


(**
 * Return the event manager of this media_list_player.
 *
 * param p_mlp media list player instance
 * @return the event manager
 *)

var
  libvlc_media_list_player_event_manager : function(
    p_mlp : libvlc_media_list_player_t_ptr
  ) : libvlc_event_manager_t_ptr; cdecl;

(**
 * Replace media player in media_list_player with this instance.
 *
 * param p_mlp media list player instance
 * param p_mi media player instance
 *)

var
  libvlc_media_list_player_set_media_player : procedure(
    p_mlp : libvlc_media_list_player_t_ptr;
    p_mi  : libvlc_media_player_t_ptr
  ); cdecl;

(**
 * Set the media list associated with the player
 *
 * param p_mlp media list player instance
 * param p_mlist list of media
 *)

var
  libvlc_media_list_player_set_media_list : procedure(
    p_mlp : libvlc_media_list_player_t_ptr;
    p_ml  : libvlc_media_list_t_ptr
  ); cdecl;

(**
 * Play media list
 *
 * param p_mlp media list player instance
 *)

var
  libvlc_media_list_player_play : procedure(
    p_mlp : libvlc_media_list_player_t_ptr
  ); cdecl;

(**
 * Pause media list
 *
 * param p_mlp media list player instance
 *)

var
  libvlc_media_list_player_pause : procedure(
    p_mlp : libvlc_media_list_player_t_ptr
  ); cdecl;

(**
 * Is media list playing?
 *
 * param p_mlp media list player instance
 * @return true for playing and false for not playing
 *)

var
  libvlc_media_list_player_is_playing : function(
    p_mlp : libvlc_media_list_player_t_ptr
  ) : Integer; cdecl;

(**
 * Get current libvlc_state of media list player
 *
 * param p_mlp media list player instance
 * @return libvlc_state_t for media list player
 *)

var
  libvlc_media_list_player_get_state : function(
    p_mlp : libvlc_media_list_player_t_ptr
  ) : libvlc_state_t; cdecl;

(**
 * Play media list item at position index
 *
 * param p_mlp media list player instance
 * param i_index index in media list to play
 * @return 0 upon success -1 if the item wasn't found
 *)

var
  libvlc_media_list_player_play_item_at_index : function(
    p_mlp   : libvlc_media_list_player_t_ptr;
    i_index : Integer
  ) : Integer; cdecl;

(**
 * Play the given media item
 *
 * param p_mlp media list player instance
 * param p_md the media instance
 * @return 0 upon success, -1 if the media is not part of the media list
 *)

var
  libvlc_media_list_player_play_item : function(
    p_mlp : libvlc_media_list_player_t_ptr;
    p_md  : libvlc_media_t_ptr
  ) : Integer; cdecl;

(**
 * Stop playing media list
 *
 * param p_mlp media list player instance
 *)

var
  libvlc_media_list_player_stop : procedure(
    p_mlp : libvlc_media_list_player_t_ptr
  ); cdecl;

(**
 * Play next item from media list
 *
 * param p_mlp media list player instance
 * @return 0 upon success -1 if there is no next item
 *)

var
  libvlc_media_list_player_next : function(
    p_mlp : libvlc_media_list_player_t_ptr
  ) : Integer; cdecl;

(**
 * Play previous item from media list
 *
 * param p_mlp media list player instance
 * @return 0 upon success -1 if there is no previous item
 *)

var
  libvlc_media_list_player_previous : function(
    p_mlp : libvlc_media_list_player_t_ptr
  ) : Integer; cdecl;

(**
 * Sets the playback mode for the playlist
 *
 * param p_mlp media list player instance
 * param e_mode playback mode specification
 *)

var
  libvlc_media_list_player_set_playback_mode : procedure(
    p_mlp  : libvlc_media_list_player_t_ptr;
    e_mode : libvlc_playback_mode_t
  ); cdecl;

(*
 *******************************************************************************
 * libvlc_media_library.h
 *******************************************************************************
 *)

(**
 * Create an new Media Library object
 *
 * param p_instance the libvlc instance
 * @return a new object or NULL on error
 *)

var
  libvlc_media_library_new : function(
    p_instance : libvlc_instance_t_ptr
  ) : libvlc_media_library_t_ptr; cdecl;

(**
 * Release media library object. This functions decrements the
 * reference count of the media library object. If it reaches 0,
 * then the object will be released.
 *
 * param p_mlib media library object
 *)

var
  libvlc_media_library_release : procedure(
    p_mlib : libvlc_media_library_t_ptr
  ); cdecl;

(**
 * Retain a reference to a media library object. This function will
 * increment the reference counting for this object. Use
 * libvlc_media_library_release() to decrement the reference count.
 *
 * param p_mlib media library object
 *)

var
  libvlc_media_library_retain : procedure(
    p_mlib : libvlc_media_library_t_ptr
  ); cdecl;

(**
 * Load media library.
 *
 * param p_mlib media library object
 * @return 0 on success, -1 on error
 *)

var
  libvlc_media_library_load : function(
    p_mlib : libvlc_media_library_t_ptr
  ) : Integer; cdecl;

(**
 * Get media library subitems.
 *
 * param p_mlib media library object
 * @return media list subitems
 *)

var
  libvlc_media_library_media_list : function(
    p_mlib : libvlc_media_library_t_ptr
  ) : libvlc_media_list_t_ptr; cdecl;

(*******************************************************************************
 * libvlc_media_discoverer.h
 *******************************************************************************
 *)

(**
 * LibVLC media discovery finds available media via various means.
 * This corresponds to the service discovery functionality in VLC media player.
 * Different plugins find potential medias locally (e.g. user media directory),
 * from peripherals (e.g. video capture device), on the local network
 * (e.g. SAP) or on the Internet (e.g. Internet radios).
 *)

(**
 * Discover media service by name.
 *
 * param p_inst libvlc instance
 * param psz_name service name
 * @return media discover object or NULL in case of error
 *)

var
  libvlc_media_discoverer_new_from_name : function(
    p_inst   : libvlc_instance_t_ptr;
    psz_name : PAnsiChar
  ) : libvlc_media_discoverer_t_ptr; cdecl;

(**
 * Release media discover object. If the reference count reaches 0, then
 * the object will be released.
 *
 * param p_mdis media service discover object
 *)

var
  libvlc_media_discoverer_release : procedure(
    p_mdis : libvlc_media_discoverer_t_ptr
  ); cdecl;

(**
 * Get media service discover object its localized name.
 *
 * param p_mdis media discover object
 * @return localized name
 *)

var
  libvlc_media_discoverer_localized_name : function(
    p_mdis : libvlc_media_discoverer_t_ptr
  ) : PAnsiChar; cdecl;

(**
 * Get media service discover media list.
 *
 * param p_mdis media service discover object
 * @return list of media items
 *)

var
  libvlc_media_discoverer_media_list : function(
    p_mdis : libvlc_media_discoverer_t_ptr
  ) : libvlc_media_list_t_ptr; cdecl;

(**
 * Get event manager from media service discover object.
 *
 * param p_mdis media service discover object
 * @return event manager object.
 *)

var
  libvlc_media_discoverer_event_manager : function(
    p_mdis : libvlc_media_discoverer_t_ptr
  ) : libvlc_event_manager_t_ptr; cdecl;

(**
 * Query if media service discover object is running.
 *
 * param p_mdis media service discover object
 * @return true if running, false if not
 *)

var
  libvlc_media_discoverer_is_running : function(
    p_mdis : libvlc_media_discoverer_t_ptr
  ) : Integer; cdecl;

(*
 *******************************************************************************
 * libvlc_vlm.h
 *******************************************************************************
 *)

(**
 * Release the vlm instance related to the given libvlc_instance_t
 *
 * param p_instance the instance
 *)

var
  libvlc_vlm_release : procedure(
    p_instance : libvlc_instance_t_ptr
  ); cdecl;

(**
 * Add a broadcast, with one input.
 *
 * param p_instance the instance
 * param psz_name the name of the new broadcast
 * param psz_input the input MRL
 * param psz_output the output MRL (the parameter to the "sout" variable)
 * param i_options number of additional options
 * param ppsz_options additional options
 * param b_enabled boolean for enabling the new broadcast
 * param b_loop Should this broadcast be played in loop ?
 * @return 0 on success, -1 on error
 *)

var
  libvlc_vlm_add_broadcast : function(
    p_instance   : libvlc_instance_t_ptr;
    psz_name     : PAnsiChar;
    psz_input    : PAnsiChar;
    psz_output   : PAnsiChar;
    i_options    : Integer;
    ppsz_options : PPAnsiChar;
    b_enabled    : Integer;
    b_loop       : Integer
  ) : Integer; cdecl;

(**
 * Add a vod, with one input.
 *
 * param p_instance the instance
 * param psz_name the name of the new vod media
 * param psz_input the input MRL
 * param i_options number of additional options
 * param ppsz_options additional options
 * param b_enabled boolean for enabling the new vod
 * param psz_mux the muxer of the vod media
 * @return 0 on success, -1 on error
 *)

var
  libvlc_vlm_add_vod : function(
    p_instance   : libvlc_instance_t_ptr;
    psz_name     : PAnsiChar;
    psz_input    : PAnsiChar;
    i_options    : Integer;
    ppsz_options : PPAnsiChar;
    b_enabled    : Integer;
    psz_mux      : PAnsiChar
  ) : Integer; cdecl;

(**
 * Delete a media (VOD or broadcast).
 *
 * param p_instance the instance
 * param psz_name the media to delete
 * @return 0 on success, -1 on error
 *)

var
  libvlc_vlm_del_media : function(
    p_instance     : libvlc_instance_t_ptr;
    psz_media_name : PAnsiChar
  ) : Integer; cdecl;

(**
 * Enable or disable a media (VOD or broadcast).
 *
 * param p_instance the instance
 * param psz_name the media to work on
 * param b_enabled the new status
 * @return 0 on success, -1 on error
 *)

var
  libvlc_vlm_set_enabled : function(
    p_instance     : libvlc_instance_t_ptr;
    psz_media_name : PAnsiChar;
    b_enabled      : Integer
  ) : Integer; cdecl;

(**
 * Set the output for a media.
 *
 * param p_instance the instance
 * param psz_name the media to work on
 * param psz_output the output MRL (the parameter to the "sout" variable)
 * @return 0 on success, -1 on error
 *)

var
 libvlc_vlm_set_output : function(
   p_instance     : libvlc_instance_t_ptr;
   psz_media_name : PAnsiChar;
   psz_output     : PAnsiChar
 ) : Integer; cdecl;

(**
 * Set a media's input MRL. This will delete all existing inputs and
 * add the specified one.
 *
 * param p_instance the instance
 * param psz_name the media to work on
 * param psz_input the input MRL
 * @return 0 on success, -1 on error
 *)

 var
  libvlc_vlm_set_input : function(
    p_instance     : libvlc_instance_t_ptr;
    psz_media_name : PAnsiChar;
    psz_input      : PAnsiChar
  ) : Integer; cdecl;

(**
 * Add a media's input MRL. This will add the specified one.
 *
 * param p_instance the instance
 * param psz_name the media to work on
 * param psz_input the input MRL
 * @return 0 on success, -1 on error
 *)

var
  libvlc_vlm_add_input : function(
    p_instance     : libvlc_instance_t_ptr;
    psz_media_name : PAnsiChar;
    psz_input      : PAnsiChar
  ) : Integer; cdecl;

(**
 * Set a media's loop status.
 *
 * param p_instance the instance
 * param psz_name the media to work on
 * param b_loop the new status
 * @return 0 on success, -1 on error
 *)

var
  libvlc_vlm_set_loop : function(
    p_instance : libvlc_instance_t_ptr;
    psz_name   : PAnsiChar;
    b_loop     : Integer
  ) : Integer; cdecl;

(**
 * Set a media's vod muxer.
 *
 * param p_instance the instance
 * param psz_name the media to work on
 * param psz_mux the new muxer
 * return 0 on success, -1 on error
 *)

var
  libvlc_vlm_set_mux : function(
    p_instance : libvlc_instance_t_ptr;
    psz_name   : PAnsiChar;
    psz_mux    : PAnsiChar
  ) : Integer; cdecl;

(**
 * Edit the parameters of a media. This will delete all existing inputs and
 * add the specified one.
 *
 * param p_instance the instance
 * param psz_name the name of the new broadcast
 * param psz_input the input MRL
 * param psz_output the output MRL (the parameter to the "sout" variable)
 * param i_options number of additional options
 * param ppsz_options additional options
 * param b_enabled boolean for enabling the new broadcast
 * param b_loop Should this broadcast be played in loop ?
 * @return 0 on success, -1 on error
 *)

var
  libvlc_vlm_change_media : function(
    p_instance   : libvlc_instance_t_ptr;
    psz_name     : PAnsiChar;
    psz_input    : PAnsiChar;
    psz_output   : PAnsiChar;
    i_options    : Integer;
    ppsz_options : PPAnsiChar;
    b_enabled    : Integer;
    b_loop       : Integer
  ) : Integer; cdecl;  

(**
 * Play the named broadcast.
 *
 * param p_instance the instance
 * param psz_name the name of the broadcast
 * @return 0 on success, -1 on error
 *)

var
  libvlc_vlm_play_media : function(
    p_instance : libvlc_instance_t_ptr;
    psz_name   : PAnsiChar
  ) : Integer; cdecl;

(**
 * Stop the named broadcast.
 *
 * param p_instance the instance
 * param psz_name the name of the broadcast
 * @return 0 on success, -1 on error
 *)

var
  libvlc_vlm_stop_media : function(
    p_instance : libvlc_instance_t_ptr;
    psz_name   : PAnsiChar
  ) : Integer; cdecl;

(**
 * Pause the named broadcast.
 *
 * param p_instance the instance
 * param psz_name the name of the broadcast
 * @return 0 on success, -1 on error
 *)

var
  libvlc_vlm_pause_media : function(
    p_instance : libvlc_instance_t_ptr;
    psz_name   : PAnsiChar
  ) : Integer; cdecl;

(**
 * Seek in the named broadcast.
 *
 * param p_instance the instance
 * param psz_name the name of the broadcast
 * param f_percentage the percentage to seek to
 * @return 0 on success, -1 on error
 *)

var
  libvlc_vlm_seek_media : function(
    p_instance   : libvlc_instance_t_ptr;
    psz_name     : PAnsiChar;
    f_percentage : Single // float
  ) : Integer; cdecl;


(**
 * Return information about the named media as a JSON
 * string representation.
 *
 * This function is mainly intended for debugging use,
 * if you want programmatic access to the state of
 * a vlm_media_instance_t, please use the corresponding
 * libvlc_vlm_get_media_instance_xxx -functions.
 * Currently there are no such functions available for
 * vlm_media_t though.
 *
 * param p_instance the instance
 * param psz_name the name of the media,
 *      if the name is an empty string, all media is described
 * @return string with information about named media, or NULL on error
 *)

var
  libvlc_vlm_show_media : function(
    p_instance : libvlc_instance_t_ptr;
    psz_name   : PAnsiChar
  ) : PAnsiChar; cdecl;

(**
 * Get vlm_media instance position by name or instance id
 *
 * param p_instance a libvlc instance
 * param psz_name name of vlm media instance
 * param i_instance instance id
 * @return position as float or -1. on error
 *)

var
  libvlc_vlm_get_media_instance_position : function(
    p_instance : libvlc_instance_t_ptr;
    psz_name   : PAnsiChar;
    i_instance : Integer
  ) : Single; cdecl;

(**
 * Get vlm_media instance time by name or instance id
 *
 * param p_instance a libvlc instance
 * param psz_name name of vlm media instance
 * param i_instance instance id
 * @return time as integer or -1 on error
 *)

var
  libvlc_vlm_get_media_instance_time : function(
    p_instance : libvlc_instance_t_ptr;
    psz_name   : PAnsiChar;
    i_instance : Integer
  ) : Integer; cdecl;

(**
 * Get vlm_media instance length by name or instance id
 *
 * param p_instance a libvlc instance
 * param psz_name name of vlm media instance
 * param i_instance instance id
 * @return length of media item or -1 on error
 *)

var
  libvlc_vlm_get_media_instance_length : function(
    p_instance : libvlc_instance_t_ptr;
    psz_name   : PAnsiChar;
    i_instance : Integer
  ) : Integer; cdecl;

(**
 * Get vlm_media instance playback rate by name or instance id
 *
 * param p_instance a libvlc instance
 * param psz_name name of vlm media instance
 * param i_instance instance id
 * @return playback rate or -1 on error
 *)

var
  libvlc_vlm_get_media_instance_rate : function(
    p_instance : libvlc_instance_t_ptr;
    psz_name   : PAnsiChar;
    i_instance : Integer
  ) : Integer; cdecl;

{$IF 0<1}
(**
 * Get vlm_media instance title number by name or instance id
 * bug will always return 0
 *
 * param p_instance a libvlc instance
 * param psz_name name of vlm media instance
 * param i_instance instance id
 * @return title as number or -1 on error
 *)

var
  libvlc_vlm_get_media_instance_title : function(
    p_instance : libvlc_instance_t_ptr;
    psz_name   : PAnsiChar;
    i_instance : Integer
  ) : Integer; cdecl;

(**
 * Get vlm_media instance chapter number by name or instance id
 * bug will always return 0
 *
 * param p_instance a libvlc instance
 * param psz_name name of vlm media instance
 * param i_instance instance id
 * @return chapter as number or -1 on error
 *)

var
  libvlc_vlm_get_media_instance_chapter : function(
    p_instance : libvlc_instance_t_ptr;
    psz_name   : PAnsiChar;
    i_instance : Integer
  ) : Integer; cdecl;

(**
 * Is libvlc instance seekable ?
 * bug will always return 0
 *
 * param p_instance a libvlc instance
 * param psz_name name of vlm media instance
 * param i_instance instance id
 * @return 1 if seekable, 0 if not, -1 if media does not exist
 *)

var
  libvlc_vlm_get_media_instance_seekable : function(
    p_instance : libvlc_instance_t_ptr;
    psz_name   : PAnsiChar;
    i_instance : Integer
  ) : Integer; cdecl;
{$IFEND}

(**
 * Get libvlc_event_manager from a vlm media.
 * The p_event_manager is immutable, so you don't have to hold the lock
 *
 * param p_instance a libvlc instance
 * @return libvlc_event_manager
 *)

var
  libvlc_vlm_get_event_manager : function(
    p_instance : libvlc_instance_t_ptr
  ) : libvlc_event_manager_t_ptr; cdecl;

(*
 *******************************************************************************
 * decpecated.h
 *******************************************************************************
 *)

{$IFDEF USE_VLC_DEPRECATED_API}

(**
 * Start playing (if there is any item in the playlist).
 *
 * Additionnal playlist item options can be specified for addition to the
 * item before it is played.
 *
 * param p_instance the playlist instance
 * param i_id the item to play. If this is a negative number, the next
 *       item will be selected. Otherwise, the item with the given ID will be
 *       played
 * param i_options the number of options to add to the item
 * param ppsz_options the options to add to the item
 *)

var
  libvlc_playlist_play : procedure(
    p_instance   : libvlc_instance_t_ptr;
    i_id         : Integer;
    i_options    : Integer;
    ppsz_options : PPAnsiChar
  ); cdecl;
  
{$ENDIF}

implementation

uses
  {$IFDEF UNIX}
  Unix, dynlibs,
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Windows, Registry,
  {$ENDIF}
  SysUtils, Classes;

const
  {$IFDEF UNIX}
  libvlc_name = 'libvlc.so';
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  libvlc_name = 'libvlc.dll';
  {$ENDIF}
  
var
  libvlc_handle : THandle;

function libvlc_delay(pts : Int64) : Int64;
begin
  Result := pts - libvlc_clock();
end;  

function libvlc_get_install_path() : string;
{$IFDEF UNIX}
begin
  // Linux searches a library in the paths of the environment variable
  // LD_LIBRARY_PATH, then in /lib, then /usr/lib and finally the paths of
  // /etc/ld.so.conf. 
  Result := '';
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
var
  r : TRegistry;
begin
  Result := '';
  r := TRegistry.Create(KEY_READ);
  try
    r.RootKey := HKEY_LOCAL_MACHINE;
    if r.OpenKey('Software\VideoLAN\VLC', FALSE) then
    begin
      if r.ValueExists('InstallDir') then
        Result := r.ReadString('InstallDir');
    end;
  finally
    r.Free;
  end;
end;
{$ENDIF}

function libvlc_dll_get_proc_addr(
  var addr   : Pointer;
  const name : PAnsiChar
  ) : Boolean;
begin
  {$IFDEF UNIX}
  addr := GetProcedureAddress(libvlc_handle, name);
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  addr := GetProcAddress(libvlc_handle, name);
  {$ENDIF}
  Result := (addr <> NIL);
  if not Result then
  begin
    libvlc_dynamic_dll_error := 'Procedure "' + name + '" not found!';
  end;
end;

procedure libvlc_dynamic_dll_init_with_path(vlc_install_path: string);
var
  cdir: string;
begin
  if (libvlc_handle <> 0) then exit;

  // no error
  libvlc_dynamic_dll_error := '';
  libvlc_dynamic_dll_path := vlc_install_path;

  // try load library 
  // before loading libvlc.dll program nust change directry to
  // libvlc_dynamic_dll_path
  if (libvlc_dynamic_dll_path <> '') then
  begin
    cdir := GetCurrentDir();
    SetCurrentDir(libvlc_dynamic_dll_path);
    {$IFDEF SUPPORTS_UNICODE}
    libvlc_handle := LoadLibrary(PWideChar(libvlc_dynamic_dll_path + '\' + libvlc_name));
    {$ELSE}
    libvlc_handle := LoadLibrary(PAnsiChar(libvlc_dynamic_dll_path + '\' + libvlc_name));
    {$ENDIF}
    SetCurrentDir(cdir);
  end
  else
  begin
    {$IFDEF SUPPORTS_UNICODE}
    libvlc_handle := LoadLibrary(PWideChar(libvlc_name));
    {$ELSE}
    libvlc_handle := LoadLibrary(PAnsiChar(libvlc_name));
    {$ENDIF}
  end;

  // exit, report error
  if (libvlc_handle = 0) then
  begin
    libvlc_dynamic_dll_error :=
      'Library not found ' + libvlc_name + ', '+
      {$IFDEF UNIX}
      'GetLastError() = ' + IntToStr(GetLastOSError())
      {$ENDIF}
      {$IFDEF MSWINDOWS}
      'GetLastError() = ' + IntToStr(GetLastError())
      {$ENDIF}
      ;
    exit;
  end;

  if not libvlc_dll_get_proc_addr(@libvlc_errmsg, // not exported in 1.0.5
    'libvlc_errmsg') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_clearerr,
    'libvlc_clearerr') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vprinterr,
    'libvlc_vprinterr') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_printerr,
    'libvlc_printerr') then exit;
  
  if not libvlc_dll_get_proc_addr(@libvlc_new,
    'libvlc_new') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_release,
    'libvlc_release') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_retain,
    'libvlc_retain') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_add_intf,
    'libvlc_add_intf') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_set_exit_handler,  // vlc 2.0.3
    'libvlc_set_exit_handler') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_wait,
    'libvlc_wait') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_set_user_agent, // vlc 1.1.1
    'libvlc_set_user_agent') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_get_version,
    'libvlc_get_version') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_get_compiler,
    'libvlc_get_compiler') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_get_changeset,
    'libvlc_get_changeset') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_free,           // vlc 2.0.3
    'libvlc_free') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_event_attach,
    'libvlc_event_attach') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_event_detach,
    'libvlc_event_detach') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_event_type_name,
    'libvlc_event_type_name') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_get_log_verbosity,
    'libvlc_get_log_verbosity') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_set_log_verbosity,
    'libvlc_set_log_verbosity') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_log_open,
    'libvlc_log_open') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_log_close,
    'libvlc_log_close') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_log_count,
    'libvlc_log_count') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_log_clear,
    'libvlc_log_clear') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_log_get_iterator,
    'libvlc_log_get_iterator') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_log_iterator_free,
    'libvlc_log_iterator_free') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_log_iterator_has_next,
    'libvlc_log_iterator_has_next') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_log_iterator_next,
    'libvlc_log_iterator_next') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_module_description_list_release,
    'libvlc_module_description_list_release') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_filter_list_get,
    'libvlc_audio_filter_list_get') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_filter_list_get,
    'libvlc_video_filter_list_get') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_new_location,
    'libvlc_media_new_location') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_new_path,
    'libvlc_media_new_path') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_new_fd, // 1.1.5
    'libvlc_media_new_fd') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_new_as_node,
    'libvlc_media_new_as_node') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_add_option,
    'libvlc_media_add_option') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_add_option_flag,
    'libvlc_media_add_option_flag') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_retain,
    'libvlc_media_retain') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_release,
    'libvlc_media_release') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_get_mrl,
    'libvlc_media_get_mrl') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_duplicate,
    'libvlc_media_duplicate') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_get_meta,
    'libvlc_media_get_meta') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_set_meta,
    'libvlc_media_set_meta') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_save_meta,
    'libvlc_media_save_meta') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_get_state,
    'libvlc_media_get_state') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_get_stats,
    'libvlc_media_get_stats') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_subitems,
    'libvlc_media_subitems') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_event_manager,
    'libvlc_media_event_manager') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_get_duration,
    'libvlc_media_get_duration') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_parse,
    'libvlc_media_parse') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_parse_async,
    'libvlc_media_parse_async') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_is_parsed,
    'libvlc_media_is_parsed') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_set_user_data,
    'libvlc_media_set_user_data') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_get_user_data,
    'libvlc_media_get_user_data') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_get_tracks_info,
    'libvlc_media_get_tracks_info') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_new,
    'libvlc_media_player_new') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_new_from_media,
    'libvlc_media_player_new_from_media') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_release,
    'libvlc_media_player_release') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_retain,
    'libvlc_media_player_retain') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_set_media,
    'libvlc_media_player_set_media') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_media,
    'libvlc_media_player_get_media') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_event_manager,
    'libvlc_media_player_event_manager') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_is_playing,
    'libvlc_media_player_is_playing') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_play,
    'libvlc_media_player_play') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_set_pause,  // 1.1.1
    'libvlc_media_player_set_pause') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_pause,
    'libvlc_media_player_pause') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_stop,
    'libvlc_media_player_stop') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_callbacks,  // 1.1.1
    'libvlc_video_set_callbacks') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_format,
    'libvlc_video_set_format') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_format_callbacks, // 2.0.3
    'libvlc_video_set_format_callbacks') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_set_nsobject,
    'libvlc_media_player_set_nsobject') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_nsobject,
    'libvlc_media_player_get_nsobject') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_set_agl,
    'libvlc_media_player_set_agl') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_agl,
    'libvlc_media_player_get_agl') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_set_xwindow,
    'libvlc_media_player_set_xwindow') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_xwindow,
    'libvlc_media_player_get_xwindow') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_set_hwnd,
    'libvlc_media_player_set_hwnd') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_hwnd,
    'libvlc_media_player_get_hwnd') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_set_callbacks,  // 2.0.3
    'libvlc_audio_set_callbacks') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_set_volume_callback, // 2.0.3
    'libvlc_audio_set_volume_callback') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_set_format_callbacks, // 2.03.
    'libvlc_audio_set_format_callbacks') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_set_format, // 2.0.3
    'libvlc_audio_set_format') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_length,
    'libvlc_media_player_get_length') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_time,
    'libvlc_media_player_get_time') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_set_time,
    'libvlc_media_player_set_time') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_position,
   'libvlc_media_player_get_position') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_set_position,
    'libvlc_media_player_set_position') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_set_chapter,
    'libvlc_media_player_set_chapter') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_chapter,
    'libvlc_media_player_get_chapter') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_chapter_count,
    'libvlc_media_player_get_chapter_count') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_will_play,
    'libvlc_media_player_will_play') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_chapter_count_for_title,
    'libvlc_media_player_get_chapter_count_for_title') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_set_title,
    'libvlc_media_player_set_title') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_title,
    'libvlc_media_player_get_title') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_title_count,
    'libvlc_media_player_get_title_count') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_previous_chapter,
    'libvlc_media_player_previous_chapter') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_next_chapter,
    'libvlc_media_player_next_chapter') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_set_rate,
    'libvlc_media_player_set_rate') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_rate,
    'libvlc_media_player_get_rate') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_state,
    'libvlc_media_player_get_state') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_get_fps,
    'libvlc_media_player_get_fps') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_has_vout,
    'libvlc_media_player_has_vout') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_is_seekable,
    'libvlc_media_player_is_seekable') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_can_pause,
    'libvlc_media_player_can_pause') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_next_frame,
    'libvlc_media_player_next_frame') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_player_navigate,  // 2.0.3
    'libvlc_media_player_navigate') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_track_description_release,
    'libvlc_track_description_release') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_toggle_fullscreen,
    'libvlc_toggle_fullscreen') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_set_fullscreen,
    'libvlc_set_fullscreen') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_get_fullscreen,
    'libvlc_get_fullscreen') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_key_input,
    'libvlc_video_set_key_input') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_mouse_input,
    'libvlc_video_set_mouse_input') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_size,
    'libvlc_video_get_size') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_cursor,
    'libvlc_video_get_cursor') then exit;

  {$IFDEF USE_VLC_DEPRECATED_API}
  if not libvlc_dll_get_proc_addr(@libvlc_video_get_height,
    'libvlc_video_get_height') then exit;
  {$ENDIF}

  {$IFDEF USE_VLC_DEPRECATED_API}
  if not libvlc_dll_get_proc_addr(@libvlc_video_get_width,
    'libvlc_video_get_width') then exit;
  {$ENDIF}

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_scale,
    'libvlc_video_get_scale') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_scale,
    'libvlc_video_set_scale') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_aspect_ratio,
    'libvlc_video_get_aspect_ratio') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_aspect_ratio,
    'libvlc_video_set_aspect_ratio') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_spu,
    'libvlc_video_get_spu') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_spu_count,
    'libvlc_video_get_spu_count') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_spu_description,
    'libvlc_video_get_spu_description') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_spu,
    'libvlc_video_set_spu') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_subtitle_file,
    'libvlc_video_set_subtitle_file') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_spu_delay,  // 2.0.3
    'libvlc_video_get_spu_delay') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_spu_delay, // 2.0.3
    'libvlc_video_set_spu_delay') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_title_description,
    'libvlc_video_get_title_description') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_chapter_description,
    'libvlc_video_get_chapter_description') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_crop_geometry,
    'libvlc_video_get_crop_geometry') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_crop_geometry,
    'libvlc_video_set_crop_geometry') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_teletext,
    'libvlc_video_get_teletext') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_teletext,
    'libvlc_video_set_teletext') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_toggle_teletext,
    'libvlc_toggle_teletext') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_track_count,
    'libvlc_video_get_track_count') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_track_description,
    'libvlc_video_get_track_description') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_track,
    'libvlc_video_get_track') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_track,
    'libvlc_video_set_track') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_take_snapshot,
    'libvlc_video_take_snapshot') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_deinterlace,
    'libvlc_video_set_deinterlace') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_marquee_int,
    'libvlc_video_get_marquee_int') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_marquee_string,
    'libvlc_video_get_marquee_string') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_marquee_int,
    'libvlc_video_set_marquee_int') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_marquee_string,
    'libvlc_video_set_marquee_string') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_logo_int,
    'libvlc_video_get_logo_int') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_logo_int,
    'libvlc_video_set_logo_int') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_logo_string,
    'libvlc_video_set_logo_string') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_adjust_int, // vlc 1.1.1
    'libvlc_video_get_adjust_int') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_adjust_int,
    'libvlc_video_set_adjust_int') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_get_adjust_float,
    'libvlc_video_get_adjust_float') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_video_set_adjust_float,
    'libvlc_video_set_adjust_float') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_output_list_get,
    'libvlc_audio_output_list_get') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_output_list_release,
    'libvlc_audio_output_list_release') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_output_set,
    'libvlc_audio_output_set') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_output_device_count,
    'libvlc_audio_output_device_count') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_output_device_longname,
    'libvlc_audio_output_device_longname') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_output_device_id,
    'libvlc_audio_output_device_id') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_output_device_set,
    'libvlc_audio_output_device_set') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_output_get_device_type,
    'libvlc_audio_output_get_device_type') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_output_set_device_type,
    'libvlc_audio_output_set_device_type') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_toggle_mute,
    'libvlc_audio_toggle_mute') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_get_mute,
    'libvlc_audio_get_mute') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_set_mute,
    'libvlc_audio_set_mute') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_get_volume,
    'libvlc_audio_get_volume') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_set_volume,
    'libvlc_audio_set_volume') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_get_track_count,
    'libvlc_audio_get_track_count') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_get_track_description,
    'libvlc_audio_get_track_description') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_get_track,
    'libvlc_audio_get_track') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_set_track,
    'libvlc_audio_set_track') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_get_channel,
    'libvlc_audio_get_channel') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_set_channel,
    'libvlc_audio_set_channel') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_get_delay, // vlc 1.1.1
    'libvlc_audio_get_delay') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_audio_set_delay,
    'libvlc_audio_set_delay') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_new,
    'libvlc_media_list_new') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_release,
    'libvlc_media_list_release') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_retain,
    'libvlc_media_list_retain') then exit;

  {$IFDEF USE_VLC_DEPRECATED_API}
  if not libvlc_dll_get_proc_addr(@libvlc_media_list_add_file_content,
    'libvlc_media_list_add_file_content') then exit;
  {$ENDIF}

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_set_media,
    'libvlc_media_list_set_media') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_media,
    'libvlc_media_list_media') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_add_media,
    'libvlc_media_list_add_media') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_insert_media,
    'libvlc_media_list_insert_media') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_remove_index,
    'libvlc_media_list_remove_index') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_count,
    'libvlc_media_list_count') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_item_at_index,
    'libvlc_media_list_item_at_index') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_index_of_item,
    'libvlc_media_list_index_of_item') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_is_readonly,
    'libvlc_media_list_is_readonly') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_lock,
    'libvlc_media_list_lock') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_unlock,
    'libvlc_media_list_unlock') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_event_manager,
    'libvlc_media_list_event_manager') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_new,
    'libvlc_media_list_player_new') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_release,
    'libvlc_media_list_player_release') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_retain, // 2.0.3
    'libvlc_media_list_player_retain') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_set_media_player,
    'libvlc_media_list_player_set_media_player') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_set_media_list,
    'libvlc_media_list_player_set_media_list') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_play,
    'libvlc_media_list_player_play') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_pause,
    'libvlc_media_list_player_pause') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_is_playing,
    'libvlc_media_list_player_is_playing') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_get_state,
    'libvlc_media_list_player_get_state') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_play_item_at_index,
    'libvlc_media_list_player_play_item_at_index') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_play_item,
    'libvlc_media_list_player_play_item') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_stop,
    'libvlc_media_list_player_stop') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_next,
    'libvlc_media_list_player_next') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_previous,
    'libvlc_media_list_player_previous') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_set_playback_mode,
    'libvlc_media_list_player_set_playback_mode') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_list_player_event_manager,
    'libvlc_media_list_player_event_manager') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_library_new,
    'libvlc_media_library_new') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_library_release,
    'libvlc_media_library_release') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_library_retain,
    'libvlc_media_library_retain') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_library_load,
    'libvlc_media_library_load') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_library_media_list,
    'libvlc_media_library_media_list') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_discoverer_new_from_name,
    'libvlc_media_discoverer_new_from_name') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_discoverer_release,
    'libvlc_media_discoverer_release') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_discoverer_localized_name,
    'libvlc_media_discoverer_localized_name') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_discoverer_media_list,
    'libvlc_media_discoverer_media_list') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_discoverer_event_manager,
    'libvlc_media_discoverer_event_manager') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_media_discoverer_is_running,
    'libvlc_media_discoverer_is_running') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_release,
    'libvlc_vlm_release') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_add_broadcast,
    'libvlc_vlm_add_broadcast') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_add_vod,
    'libvlc_vlm_add_vod') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_del_media,
    'libvlc_vlm_del_media') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_set_output,
    'libvlc_vlm_set_output') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_set_input,
    'libvlc_vlm_set_input') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_add_input,
    'libvlc_vlm_add_input') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_set_loop,
    'libvlc_vlm_set_loop') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_set_mux,
    'libvlc_vlm_set_mux') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_change_media,
    'libvlc_vlm_change_media') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_play_media,
    'libvlc_vlm_play_media') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_stop_media,
    'libvlc_vlm_stop_media') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_pause_media,
    'libvlc_vlm_pause_media') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_seek_media,
    'libvlc_vlm_seek_media') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_show_media,
    'libvlc_vlm_show_media') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_get_media_instance_position,
    'libvlc_vlm_get_media_instance_position') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_get_media_instance_time,
    'libvlc_vlm_get_media_instance_time') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_get_media_instance_length,
    'libvlc_vlm_get_media_instance_length') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_get_media_instance_rate,
    'libvlc_vlm_get_media_instance_rate') then exit;

  if not libvlc_dll_get_proc_addr(@libvlc_vlm_get_event_manager,
    'libvlc_vlm_get_event_manager') then exit;

  {$IF 0<1}
  // if not libvlc_dll_get_proc_addr(@libvlc_vlm_get_media_instance_title,
  //   'libvlc_vlm_get_media_instance_title') then exit;
  // if not libvlc_dll_get_proc_addr(@libvlc_vlm_get_media_instance_chapter,
  //   'libvlc_vlm_get_media_instance_chapter') then exit;
  // if not libvlc_dll_get_proc_addr(@libvlc_vlm_get_media_instance_seekable,
  //   'libvlc_vlm_get_media_instance_seekable') then exit;
  {$IFEND}

  {$IFDEF USE_VLC_DEPRECATED_API}
  if not libvlc_dll_get_proc_addr(@libvlc_playlist_play,
    'libvlc_playlist_play') then exit;
  {$ENDIF}
end;

procedure libvlc_dynamic_dll_init();
begin
  if (libvlc_handle <> 0) then exit;
  libvlc_dynamic_dll_init_with_path(libvlc_get_install_path());
end;

procedure libvlc_dynamic_dll_done();
begin
  {$IFDEF UNIX}
  if (libvlc_handle <> 0) then UnloadLibrary(libvlc_handle);
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  if (libvlc_handle <> 0) then FreeLibrary(libvlc_handle);
  {$ENDIF}
end;

initialization

  libvlc_handle := 0;
  
finalization

end.
