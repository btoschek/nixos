{ config, lib, pkgs, ... }:

let
  cfg = config.userSettings.mpd;

  source = "/tmp/mpd.fifo";
  sample_rate = "44100";
  channels = "2";
  sample_bits = "16";

  background = config.lib.stylix.colors.base00;
  foreground = config.lib.stylix.colors.base05;
in
{
  options = {
    userSettings.mpd = {
      enable = lib.mkEnableOption "Enable mpd and peripherals";
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      cava
    ];

    # Custom rmpc theme (everything related to visuals)
    home.file."./.config/rmpc/themes/custom.ron".text = ''
      #![enable(implicit_some)]
      #![enable(unwrap_newtypes)]
      #![enable(unwrap_variant_newtypes)]
      (
        show_song_table_header: false,
        draw_borders: true,
        browser_column_widths: [20, 38, 42],
        background_color: "#${background}",
        modal_backdrop: true,
        text_color: "#${foreground}",
        header_background_color: "#${background}",
        modal_background_color: "#${background}",
        preview_label_style: (fg: "#${foreground}"),
        preview_metadata_group_style: (fg: "#81a1c1"),
        song_table_album_separator: None,

        tab_bar: (
          enabled: true,
          active_style: (fg: "#2e3440", bg: "#81A1C1", modifiers: "Bold"),
          inactive_style: (fg: "#d8dee9", bg: "#${background}"),
        ),

        highlighted_item_style: (fg: "#a3be8c", modifiers: "Bold"),
        current_item_style: (fg: "#2e3440", bg: "#81a1c1", modifiers: "Bold"),
        borders_style: (fg: "#81a1c1", modifiers: "Bold"),
        highlight_border_style: (fg: "#81a1c1"),
        symbols: (
          song: "󰝚 ",
          dir: " ",
          playlist: "󰲸 ",
          marker: "* ",
          ellipsis: "...",
          song_style: (fg: "#81a1c1"),  // TODO: Adjust
          dir_style: (fg: "#81a1c1")
        ),
        progress_bar: (
          symbols: ["", "█", "", "█", "" ],
        ),

        scrollbar: (
          symbols: ["┋", "█", "󰄿", "󰄼"],
          track_style: (fg: "#81a1c1"),
          ends_style: (fg: "#81a1c1"),
          thumb_style: (fg: "#81a1c1"),
        ),

      song_table_format: [
        (
          prop: (kind: Transform(Replace(content: (kind: Sticker("rating")), replacements: [
              (match:  "0", replace: (kind: Group([(kind: Text("󰎡"))]))),
              (match:  "1", replace: (kind: Group([(kind: Text("󰎤"),style: (fg: "#81a1c1"))]))),
              (match:  "2", replace: (kind: Group([(kind: Text("󰎧"),style: (fg: "#81a1c1"))]))),
              (match:  "3", replace: (kind: Group([(kind: Text("󰎪"),style: (fg: "#81a1c1"))]))),
              (match:  "4", replace: (kind: Group([(kind: Text("󰎭"),style: (fg: "#81a1c1"))]))),
              (match:  "5", replace: (kind: Group([(kind: Text("󰎱"),style: (fg: "#81a1c1"))]))),
              (match:  "6", replace: (kind: Group([(kind: Text("󰎳"),style: (fg: "#81a1c1"))]))),
              (match:  "7", replace: (kind: Group([(kind: Text("󰎶"),style: (fg: "#81a1c1"))]))),
              (match:  "8", replace: (kind: Group([(kind: Text("󰎹"),style: (fg: "#81a1c1"))]))),
              (match:  "9", replace: (kind: Group([(kind: Text("󰎼"),style: (fg: "#81a1c1"))]))),
              (match: "10", replace: (kind: Group([(kind: Text("󰽽"),style: (fg: "#81a1c1"))]))),
          ])), default: (kind: Text(" "), style: (fg: "#5e81ac"))),
          width: "3",
          label: "Rating",
          alignment: Left,
        ),
        (
          prop: (kind: Property(Artist), style: (fg: "#${foreground}"),
            default: (kind: Text("Unknown Artist"), style: (fg: "#${foreground}"))),
          width: "21%"
        ),
        (
          prop: (kind: Property(Title), style: (fg: "#88c0d0"),
            default: (kind: Property(Filename), style: (fg: "#d8dee9"))),
          width: "45%"
        ),
        (
          prop: (kind: Property(Album), style: (fg: "#81a1c1"),
            default: (kind: Text("Unknown Album"), style: (fg: "#b48ead"))),
          width: "34%"
        ),
        (
          prop: (kind: Property(Duration), style: (fg: "#88c0d0"),
            default: (kind: Text("-"))),
          width: "5%", alignment: Right
        ),
      ],

      layout: Split(
          direction: Vertical, panes: [
              (size: "3", pane: Pane(Tabs)),
              (size: "4", borders: "ALL", pane: Component("custom-header")),
              (size: "100%", borders: "NONE", pane: Pane(TabContent)),
              (size: "3", borders: "TOP | BOTTOM", pane: Pane(ProgressBar)),
          ]),

      header: (rows: []),

      browser_song_format: [
          (kind: Group([
                      (kind: Property(Track)),
                      (kind: Text(" ")),
                  ])),
          (kind: Group([
                      (kind: Property(Artist)),
                      (kind: Text(" - ")),
                      (kind: Property(Title)),
                  ]), default: (kind: Property(Filename)))
      ],

      level_styles: (
          info:  (fg: "#a3be8c", bg: "#2e3440"),
          warn:  (fg: "#ebcb8b", bg: "#2e3440"),
          error: (fg: "#bf616a", bg: "#2e3440"),
          debug: (fg: "#d08770", bg: "#2e3440"),
          trace: (fg: "#b48ead", bg: "#2e3440"),
      ),

      components: {
          "custom_song_table_header": Split(borders: "ALL", direction: Horizontal, panes: [
                  (size: "5", pane: Pane(Property(content: [
                                  (kind: Text(" 󰩳"), style: (fg: "#81a1c1")),
                              ], align: Left))
                  ),
                  (size: "21%", pane: Pane(Property(content: [
                                  (kind: Text("Artist "), style: (fg: "#d8dee9")),
                                  (kind: Text(""), style: (fg: "#81a1c1"))
                              ], align: Left))
                  ),
                  (size: "39%", pane: Pane(Property(content: [
                                  (kind: Text("Title "), style: (fg: "#d8dee9")),
                                  (kind: Text(""), style: (fg: "#81a1c1"))
                              ], align: Left))
                  ),
                  (size: "33%", pane: Pane(Property(content: [
                                  (kind: Text("Album "), style: (fg: "#d8dee9")),
                                  (kind: Text("󰀥"), style: (fg: "#81a1c1"))
                              ], align: Left))
                  ),
                  (size: "7%", pane: Pane(Property(content: [
                                  (kind: Text("Length "), style: (fg: "#d8dee9")),
                                  (kind: Text(" "), style: (fg: "#81a1c1"))
                              ], align: Right))
                  ),
                  (size: "1", pane: Pane(Property(content: [
                                  (kind: Text(" "), style: (fg: "#81a1c1")),
                              ], align: Left))
                  ),
              ]),

          "custom-header": Split(direction: Horizontal, panes: [
                  (size: "33%", pane: Split(direction: Vertical, panes: [
                              (size: "100%", pane: Pane(Property(content: [
                                              (kind: Text(""), style: (fg: "#81a1c1", modifiers: "Bold")),
                                              (kind: Property(Status(StateV2(playing_label: "  ", paused_label: "  ", stopped_label: "  "))),style: (fg: "#d8dee9")),
                                              (kind: Text(" "), style: (fg: "#81a1c1", modifiers: "Bold")),
                                              (kind: Property(Widget(ScanStatus)), style: (fg: "#d8dee9", modifiers: "Bold"))
                                          ], align: Left))
                              ),
                              (size: "100%", pane: Pane(Property(content: [
                                              (kind: Text("[ "),style: (fg: "#81a1c1", modifiers: "Bold")),
                                              (kind: Property(Status(Elapsed)),style: (fg: "#d8dee9")),
                                              (kind: Text(" / "),style: (fg: "#81a1c1", modifiers: "Bold")),
                                              (kind: Property(Status(Duration)),style: (fg: "#d8dee9")),
                                              (kind: Text(" | "),style: (fg: "#81a1c1", modifiers: "Bold")),
                                              (kind: Property(Status(Bitrate)),default: (kind: Text(" ")),style: (fg: "#d8dee9")),
                                              (kind: Text(" kbps"),style: (fg: "#81a1c1")),
                                              (kind: Text(" ]"),style: (fg: "#81a1c1", modifiers: "Bold"))
                                          ], align: Left))
                              ),
                          ])
                  ),
                  (size: "34%", pane: Split(direction: Vertical, panes: [
                              (size: "100%", pane: Pane(Property(content: [
                                              (kind: Property(Song(Title)), style: (fg: "#d8dee9",modifiers: "Bold"),
                                                  default: (kind: Property(Song(Filename)), style: (fg: "#d8dee9",modifiers: "Bold")))
                                          ], align: Center))
                              ),
                              (size: "100%", pane: Pane(Property(content: [
                                              (kind: Property(Song(Artist)), style: (fg: "#88c0d0"),
                                                  default: (kind: Text("Unknown Artist"), style: (fg: "#88c0d0"))),
                                              (kind: Text(" - "), style: (fg: "#d8dee9")),
                                              (kind: Property(Song(Album)),style: (fg: "#81a1c1" ),
                                                  default: (kind: Text("Unknown Album"), style: (fg: "#81a1c1")))
                                          ], align: Center))
                              ),
                          ])
                  ),
                  (size: "33%", pane: Split(direction: Vertical, panes: [
                              (size: "100%", pane: Pane(Property(content: [
                                              (kind: Text(" 󱡬"), style: (fg: "#81a1c1", modifiers: "Bold")),
                                              (kind: Property(Status(Volume)), style: (fg: "#d8dee9")),
                                              (kind: Text("% "), style: (fg: "#81a1c1", modifiers: "Bold"))
                                          ], align: Right))
                              ),
                              (size: "100%", pane: Pane(Property(content: [
                                              (kind: Text("[ "),style: (fg: "#81a1c1", modifiers: "Bold")),
                                              (kind: Property(Status(QueueLength())),style: (fg: "#d8dee9")),
                                              (kind: Text(" 󰴍 | "),style: (fg: "#81a1c1", modifiers: "Bold")),
                                              (kind: Property(Status(QueueTimeTotal(separator: " "))),style: (fg: "#d8dee9")),
                                              (kind: Text(" 󱎫 | "),style: (fg: "#81a1c1", modifiers: "Bold")),
                                              (kind: Property(Status(RepeatV2(on_label: "", off_label: "",
                                                              on_style: (fg: "#d8dee9", modifiers: "Bold"), off_style: (fg: "#4c566a", modifiers: "Bold"))))),
                                              (kind: Text(" | "),style: (fg: "#81a1c1", modifiers: "Bold")),
                                              (kind: Property(Status(RandomV2(on_label: "", off_label: "",
                                                              on_style: (fg: "#d8dee9", modifiers: "Bold"), off_style: (fg: "#4c566a", modifiers: "Bold"))))),
                                              (kind: Text(" | "),style: (fg: "#81a1c1", modifiers: "Bold")),
                                              (kind: Property(Status(ConsumeV2(on_label: "󰮯", off_label: "󰮯", oneshot_label: "󰮯󰇊",
                                                              on_style: (fg: "#d8dee9", modifiers: "Bold"), off_style: (fg: "#4c566a", modifiers: "Bold"))))),
                                              (kind: Text(" | "),style: (fg: "#81a1c1", modifiers: "Bold")),
                                              (kind: Property(Status(SingleV2(on_label: "󰎤", off_label: "󰎦", oneshot_label: "󰇊", off_oneshot_label: "󱅊",
                                                              on_style: (fg: "#d8dee9", modifiers: "Bold"), off_style: (fg: "#4c566a", modifiers: "Bold"))))),
                                              (kind: Text(" ]"),style: (fg: "#81a1c1", modifiers: "Bold")),
                                          ], align: Right))
                              ),
                          ])
                  ),
              ])
      },
      )
    '';

    programs.rmpc = {
      enable = true;
      config = ''
        #![enable(implicit_some)]
        #![enable(unwrap_newtypes)]
        #![enable(unwrap_variant_newtypes)]
        (
          theme: Some("custom"),
          lyrics_dir: Some("~/Music/"),
          tabs: [
            (name: "Home", pane: Split(direction: Horizontal, panes: [
                (size: "35%", borders: "NONE", pane: Split(direction: Vertical, panes: [
                    (size: "100%", borders: "ALL", pane: Pane(AlbumArt)),
                  ])
                ),
                (size: "65%", borders: "NONE", pane: Split(direction: Vertical, panes: [
                    (size: "60%", borders: "ALL", pane: Pane(Queue)),
                    (size: "40%", borders: "ALL", pane: Pane(Cava)),
                  ])
                ),
              ])
            ),
            (name: "Current", pane: Split(direction: Vertical, panes: [
                (size: "50%", pane: Split(direction: Horizontal, panes: [
                    (size: "78%", borders: "ALL", pane: Pane(Queue)),
                    (size: "22%", borders: "ALL", pane: Pane(AlbumArt)),
                  ])
                ),
                (size: "50%", pane: Split(direction: Horizontal, panes: [
                    (size: "50%", borders: "ALL", pane: Pane(Cava)),
                    (size: "50%", borders: "ALL", pane: Pane(Lyrics)),
                  ])
                ),
              ])
            ),
            (name: "Playlists", pane: Split(direction: Horizontal, panes: [
                (size: "100%", borders: "ALL", pane: Pane(Playlists)),
              ])
            ),
            (name: "Artists", pane: Split(direction: Horizontal, panes: [
                (size: "100%", borders: "ALL", pane: Pane(Artists)),
              ])
            ),
            (name: "Albums", pane: Split(direction: Horizontal, panes: [
                (size: "100%", borders: "ALL", pane: Pane(Albums)),
              ])
            ),
            (name: "Genres", pane: Split(direction: Horizontal, panes: [
                (size: "100%", borders: "ALL", pane: Pane(Browser(root_tag: "genre", separator: ";"))),
              ])
            ),
            (name: "Queue", pane: Split(direction: Horizontal, panes: [
                (size: "100%", borders: "ALL", pane: Pane(Queue))
              ])
            ),
            (name: "Search", pane: Split(direction: Horizontal, panes: [
                (size: "100%", borders: "ALL", pane: Pane(Search)),
              ])
            ),
          ],
          cava: (
            framerate: 60,
            autosens: true,
            sensitivity: 100,
            lower_cutoff_freq: 50,
            higher_cutoff_freq: 10000,
            input: (
              method: Fifo,
              source: "${source}",
              sample_rate: ${sample_rate},
              channels: ${channels},
              sample_bits: ${sample_bits},
            ),
            smoothing: (
              noise_reduction: 77,
              monstercat: false,
              waves: false,
            ),
            eq: []
          )
        )
      '';
    };

    services.mpd = {
      enable = true;

      musicDirectory = "${config.home.homeDirectory}/Music";

      # TODO: https://wiki.archlinux.org/title/Music_Player_Daemon#Listen_on_Unix_domain_socket
      extraConfig = ''
        auto_update "yes"
        restore_paused "yes"

        audio_output {
          type "pipewire"
          name "PipeWire Sound Server"
        }

        audio_output {
          type "fifo"
          name "Visualizer feed"
          path "${source}"
          format "${sample_rate}:${sample_bits}:${channels}"
        }
      '';

      network = {
        listenAddress = "127.0.0.1";
      };
    };
  };
}
