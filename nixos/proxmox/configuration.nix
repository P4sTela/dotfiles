# NixOS on Proxmox VM 設定 (UEFI / VirtIO)
{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    # VirtIO (virtio_blk / virtio_net 等) の initrd モジュールを有効化
    (modulesPath + "/profiles/qemu-guest.nix")
    ../common.nix
    ./disk-config.nix
  ];

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "proxmox";

  # DHCP でネットワーク取得
  networking.useDHCP = lib.mkDefault true;

  # root での SSH ログインを許可 (公開鍵のみ / ラボ用途)
  # common.nix の PermitRootLogin = "no" をこのホストだけ上書き
  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwN9ZPsnvpCcR72ofZwj9sc8OU1MrNwuc+YkQ5VYumY"
  ];

  # Proxmox / QEMU ゲストエージェント
  services.qemuGuest.enable = true;

  # ブートローダー (UEFI / systemd-boot)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # ESP を /boot/efi にマウントしているため明示
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # このホスト固有のパッケージ
  environment.systemPackages = with pkgs; [
    # コンテナベースのネットワークラボ (Docker は common.nix で有効化済み)
    containerlab

    # 診断・解析
    tcpdump
    wireshark-cli # tshark
    mtr
    traceroute
    nmap
    socat
    netcat-gnu
    dnsutils # dig / nslookup
    ethtool

    # トラフィック生成・帯域測定
    iperf3
    netperf
    netsniff-ng # trafgen など
    (python3.withPackages (ps: with ps; [ scapy ]))
  ];

  # NixOS の状態バージョン
  system.stateVersion = "25.05";
}
