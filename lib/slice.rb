class Slice
  def run(command)
    `#{MOUNT_POINT}/#{command}`.chomp
  end
end
