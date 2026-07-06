{ config, ... }:
{
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=2 video_nr=1,2 card_label="OBS Cam, Camera" exclusive_caps=1
  '';
  #programs.obs-studio.enableVirtualCamera = true;
}
