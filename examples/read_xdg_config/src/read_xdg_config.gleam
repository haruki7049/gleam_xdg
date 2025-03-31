import gleam/io
import xdgleam

pub fn main() {
  let base_dirs = xdgleam.new()

  io.println(base_dirs.config_home)
}
