{ lib, ... }@args:

let
  callPackage = lib.callPackageWith args;
in
{
  ricoh-sp150suw-ppd = callPackage ./ricoh-sp150suw-ppd {};
}