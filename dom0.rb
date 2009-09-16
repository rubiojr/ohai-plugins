provides "dom0"

require_plugin 'ruby'

dom0 Mash.new unless attribute?('dom0')
case languages[:ruby][:host_os]
when /mswin/
  # Windows dom0? :D
else
  dom0[:guest_list] = []
  from("xm list | awk '{ print $1 }' |egrep -v '^(Domain-0|Name)'").each_line do |g|
    dom0[:guest_list] << g
  end
end

