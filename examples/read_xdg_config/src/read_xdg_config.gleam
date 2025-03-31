import gleam/io
import gleam_xdg

pub fn main() {
  let base_dirs = gleam_xdg.new()

  io.println(base_dirs.config_home)
}
