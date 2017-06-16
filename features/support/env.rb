require 'aruba/cucumber'

Before do
  @aruba_timeout_seconds = 10 # too slow on sloppy machines
end

#After do
#  FileUtils.rm_rf('tmp')
#end
