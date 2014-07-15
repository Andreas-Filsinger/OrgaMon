<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<?php

    /*******************************************************************
     * Shop Index                                                      *
     *-----------------------------------------------------------------*
     *                                                                 *
     * Indexdatei für tWebshop, welche den eigentlich Shop als iFrame  *
     * einbindet, damit der jPlayer persistent spielen kann. Wenn      *
     * diese Seite mit Argument aufgerufen wird, werden diese an den   *
     * Shop weitergegeben.                                             *
     *                                                                 *
     * Das im Shop konfigurierte Template wird beachtet.               *
     *                                                                 *
     *-----------------------------------------------------------------*
     * 27.06.2014 | Michael Hack Software | www.michaelhacksoftware.de *
     *******************************************************************/

    include_once("config.php");

    /* === Parameter an Shop weiterleiten === */
    $Site = "./shop.php";

    if ($_SERVER['QUERY_STRING']) {
        $Site .= "?" . $_SERVER['QUERY_STRING'];
    }

?>
<html>

    <head>

        <meta http-equiv="X-UA-Compatible" content="IE=9">
        
        <script type="text/javascript" src="./js/jquery.js"></script>
        <script type="text/javascript" src="./js/jplayer/jplayer.js"></script>
        <script type="text/javascript" src="./js/jplayer/jplayer-playlist.js"></script>

        <link href="./templates/<?php echo TWEBSHOP_TEMPLATE; ?>/jplayer.css" rel="stylesheet" type="text/css">

        <script type="text/javascript">

            var myPlaylist;
            var isPlaying = false;

            /* 27.06.2014 michaelhacksoftware : jPlayer vorbereiten */
            $(document).ready(function(){

                myPlaylist = new jPlayerPlaylist({
                    jPlayer: "#jp_player_1",
                    cssSelectorAncestor: "#jp_container_1"
                }, [], {
                    playlistOptions: {
                        enableRemoveControls: true
                    },
                    swfPath: "js/jplayer",
                    supplied: "mp3",
                    smoothPlayBar: true
                });

                $("#jp_player_1").bind($.jPlayer.event.play, function(event) {
                    isPlaying = true;
                });

                $("#jp_player_1").bind($.jPlayer.event.pause, function(event) {
                    isPlaying = false;
                });

            });
            /* --- */

            /* 08.07.2014 michaelhacksoftware : ResizeFunction für den iFrame */
            function ResizeFrame() {

                var frame   = document.getElementById('frmShop');
                var content = frmShop.document.getElementsByTagName('body')[0];

                frame.scrolling        = 'no';
                content.style.overflow = 'hidden';

                var height = eval(content.offsetHeight + 20) + 'px';

                if (document.all && !window.opera) {
                    height = eval(content.scrollHeight + 20) + 'px';
                }

                if (frame.style.height != height) {
                    frame.style.height = height;
                }

                scrollTo(0, 0);

            }
            /* --- */

        </script>

    </head>

    <body>

        <div id="jp_container_1" class="jp-audio">

            <div class="jp-type-playlist">

                <div id="jp_player_1" class="jp-jplayer"></div>

                <div class="jp-gui">

                    <div class="jp-interface">

                        <div class="jp-progress">
                            <div class="jp-seek-bar">
                                <div class="jp-play-bar"></div>
                            </div>
                        </div>

                        <div class="jp-current-time"></div>
                        <div class="jp-duration"></div>

                        <div class="jp-volume-holder">

                            <div class="jp-volume-bar">
                                <div class="jp-volume-bar-value"></div>
                            </div>

                            <ul class="jp-controls">
                                <li><a href="javascript:;" class="jp-mute" tabindex="1" title="mute">mute</a></li>
                                <li><a href="javascript:;" class="jp-unmute" tabindex="1" title="unmute">unmute</a></li>
                                <li><a href="javascript:;" class="jp-volume-max" tabindex="1" title="max volume">max volume</a></li>
                            </ul>

                        </div>

                        <div class="jp-controls-holder">
                            <ul class="jp-controls">
                                <li><a href="javascript:;" class="jp-previous" tabindex="1">previous</a></li>
                                <li><a href="javascript:;" class="jp-play" tabindex="1">play</a></li>
                                <li><a href="javascript:;" class="jp-pause" tabindex="1">pause</a></li>
                                <li><a href="javascript:;" class="jp-next" tabindex="1">next</a></li>
                                <li><a href="javascript:;" class="jp-stop" tabindex="1">stop</a></li>
                            </ul>
                        </div>

                    </div>

                </div>

                <div class="jp-playlist"><ul><li></li></ul></div>

            </div>

        </div>

        <iframe id="frmShop" name="frmShop" src="<?php echo $Site; ?>" onload="ResizeFrame()" width="100%" height="100%" frameborder="0" scrolling="yes"></iframe>

    </body>

</html>