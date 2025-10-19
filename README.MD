## NixOS Config 

### SHIZZA-MINI (Lenovo IdeaPad Slim 5 14AHP9)

- CPU: AMD Ryzen 5 8645HS
- GPU: AMD Radeon 760M
- Monitor: OLED HDR 1920/1200 14"

Net install (root mounted into /mnt)
```sh
nixos-install --root /mnt --flake github:Urtyom-Alyanov/nix-config#SHIZZA-MINI
```

Offline install (root mounted into /mnt)
```sh
nixos-install --root /mnt --flake .../flake-dir#SHIZZA-MINI
```

### SHIZZA

- CPU: Intel Core i5 11400F
- GPU: NVIDIA RTX 4060
- Monitor: MiniLED HDR 2560/1440 27"

Net install (root mounted into /mnt)
```sh
nixos-install --root /mnt --flake github:Urtyom-Alyanov/nix-config#SHIZZA
```

Offline install (root mounted into /mnt)
```sh
nixos-install --root /mnt --flake .../flake-dir#SHIZZA
```