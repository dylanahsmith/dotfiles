def count_allocations
  require 'stackprof'
  profile = StackProf.run(mode: :object) do
    yield
  end
  profile[:samples]
end

def run_profile(mode: :cpu, save_to: false, report: true)
  require 'stackprof'
  profile = StackProf.run(mode: mode) do
    yield
  end
  report_object = StackProf::Report.new(profile)
  if report
    report_object.print_text(false, 20)
  end
  File.binwrite(save_to, Marshal.dump(profile)) if save_to
  report_object
end
