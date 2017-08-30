DEBUG = false

def puts(s)
  print("@Tool@: ")
  super
end



def help
  puts "Command is called incorrectly."
  puts "----------------------------------------------------------------"
  puts "Usage: uninstallapp [--help]|[--all]|[device-serial+] package"
  puts "----------------------------------------------------------------"
  puts "Examples:"
  puts ("")
  puts "Remove app from all devices:"
  puts "uninstallapp --all package"
  puts ("")
  puts "Remove app from single device:"
  puts "uninstallapp 23465b com.sample"
  puts ("")
  puts "Remove app from selected devices:"
  puts "uninstallapp 23465b 23245f65b com.sample"
end


def get_devices
  begin
    device_list = `adb devices`
    #Get list of devices
    #Example:
    #adb devices =>
    # List of devices attached
    # CB5A1PQ8ZG	device
    # 0855c09b	device
    # 78F5FD2F70CC	device
    #

    devices = device_list.split("\n")
    #Remove "List of devices attached".
    devices = devices.drop(1)
    i = 0
    #Remove tab between serial-nummber and "device".
    devices.each do|device|
      temps = device.split("\t")
      devices[i] = temps[0]
      i += 1
    end
    puts("Find devices:#{devices.inspect}")
    devices
  rescue
    nil
  end
end

def get_package(package)
  is_valid = !(package =~ /^[a-z][a-z0-9_]*(\.[a-z0-9_]+)+[0-9a-z_]$/i)
  if is_valid then
      puts "Wrong package: #{package}"
      false
  else
      puts "It is a real package: #{package}"
      true
  end
end

def uninstall_package(devices, package)
  if devices.instance_of? String then
    puts("Removed #{package} on #{devices}")
    cmd = `adb -s #{devices} uninstall #{package}`
    puts(cmd)
  else
    devices.each do|device|
      puts("Removed #{package} on #{device}")
      cmd = `adb -s #{device} uninstall #{package}`
      puts(cmd)
    end
  end

end

def parse_args(args_count)
  case args_count
  when 2
    package = ARGV[args_count - 1]
    if get_package(package) then
        devices = get_devices
        if ARGV.include?('--all') then #Push app to all on PC connected devices.
          if devices != nil then
            uninstall_package(devices, package)
          end
        else #Push app to only one selected device.
            device = ARGV[0]
            if devices.include?(device) then
              uninstall_package(device, package)
            else
              puts("Excluded(not found device): #{device}")
              puts("No device(s) found!")
            end
        end
    end
  else
    if ARGV.include?('--all') then
        puts "Error: --all option cannot be used when device-serial is used."
        help
    else
        package = ARGV[args_count - 1]
        if get_package(package) then #Push app to selected devices.
            devices = ARGV[0...args_count-1]
            found_devices = get_devices
            #To find device that doesnot connect to PC.
            excluded_devices = devices - found_devices
            if excluded_devices.length > 0 then
                puts( "Excluded(not found device(s)): #{excluded_devices}")
                #Remove not found device-serial.
                devices -= excluded_devices
            end
            if devices != nil && devices.length > 0 then
                uninstall_package(devices, package)
            else
                puts("No device(s) found!")
            end
        end
    end
  end
end


def main
  args_count = ARGV.length
  if args_count > 1 then
    if DEBUG then
      puts "Args count #{ARGV.length}"
      ARGV.each do|a|
        puts "Argument: #{a}"
      end
    end
    if ARGV.include?('--help') then
      help
    else
      parse_args(args_count)
    end
  else
    help
  end
end

main
