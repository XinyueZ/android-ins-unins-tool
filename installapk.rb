DEBUG = false

def puts(s)
  print("@Tool@: ")
  super
end



def help
  puts "Command is called incorrectly."
  puts "----------------------------------------------------------------"
  puts "Usage: installapk [--help]|[--all]|[device-serial+] apk-path"
  puts "----------------------------------------------------------------"
  puts "Examples:"
  puts ("")
  puts "Install app to all devices:"
  puts "installapk --all filename"
  puts ("")
  puts "Install app to single device:"
  puts "installapk 23465b filename"
  puts ("")
  puts "Install app to selected devices:"
  puts "installapk 23465b 23245f65b filename"
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

def get_apk(apk)
  if !File.exist?(apk) then
      puts "Cannot find APK file: #{apk}"
      false
  else
      puts "Find APK file: #{apk}"
      true
  end
end

def install_apk(devices, apk)
  if devices.instance_of? String then
    puts("Setup #{apk} on #{devices}")
    cmd = `adb -s #{devices} install -r #{apk}`
    puts(cmd)
  else
    devices.each do|device|
      puts("Setup #{apk} on #{device}")
      cmd = `adb -s #{device} install -r #{apk}`
      puts(cmd)
    end
  end
end

def parse_args(args_count)
  case args_count
  when 2
    apk = ARGV[args_count - 1]
    if get_apk(apk) then
        devices = get_devices
        if ARGV.include?('--all') then #Push app to all on PC connected devices.
          if devices != nil then
            install_apk(devices, apk)
          end
        else #Push app to only one selected device.
            device = ARGV[0]
            if devices.include?(device) then
              install_apk(device, apk)
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
        apk = ARGV[args_count - 1]
        if get_apk(apk) then #Push app to selected devices.
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
                install_apk(devices, apk)
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
