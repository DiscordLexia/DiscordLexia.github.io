{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  name = "CodingInReverse";
  buildInputs = with pkgs; [godot];
}
