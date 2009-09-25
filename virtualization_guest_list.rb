require_plugin 'ruby'
require_plugin 'virtualization'

# Build the guest list
case languages[:ruby][:host_os]
when /mswin/
  # Windows dom0? :D
else
  if File.exists?("/proc/xen/capabilities") && File.read("/proc/xen/capabilities") =~ /control_d/i
    virtualization[:guest_list] = []
    from("xm list | awk '{ print $1 }' |egrep -v '^(Domain-0|Name)'").each_line do |g|
      virtualization[:guest_list] << g
    end
  end
end

