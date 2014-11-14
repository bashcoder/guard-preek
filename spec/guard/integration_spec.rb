require 'spec_helper'

describe Guard::Preek do
  include CaptureHelper

  Given(:guard){ Guard::Preek.new(options) }
  Given(:options){ Hash.new }

  context '#run_on_changes' do
    Given(:paths){ ["spec/test_files/#{file}.rb"] }
    When(:output) { capture(:stdout) { guard.run_on_changes(paths) } }

    context 'with no options' do
      context 'with a smell' do
        Given(:file) {'nil_check'}
        Then { output.should match(/NilCheck/) }
        Then { output.should include(paths[0])}
      end

      context 'with Irresponsible' do
        Given(:file) {'irresponsible'}
        Then { output.should match(/No smells detected/) }
        Then { output.should_not include(paths[0])}
      end

      context 'without smell' do
        Given(:file) {'non_smelly'}
        Then { output.should match(/No smells detected/) }
        Then { output.should_not include(paths[0])}
      end
    end

    context 'with option "report: :verbose"' do
      Given(:options){ {report: :verbose} }

      context 'with a smell' do
        Given(:file) {'nil_check'}
        Then { output.should match(/NilCheck/) }
        Then { output.should include(paths[0])}
      end

      context 'with Irresponsible' do
        Given(:file) {'irresponsible'}
        Then { output.should match(/No smells detected/) }
        Then { output.should include(paths[0])}
      end

      context 'without smell' do
        Given(:file) {'non_smelly'}
        Then { output.should match(/No smells detected/) }
        Then { output.should include(paths[0])}
      end
    end

  end

  context '#run_all' do
    context 'with "run_all_dir" option' do
      Given(:options){ {run_all_dir: 'spec/test_files'} }
      When(:output) { capture(:stdout) { guard.run_all } }
      Then{ output.should match /NilCheck/ }
      Then{ output.should match /TooManyStatements/ }
      Then{ output.should_not match /Irresponsible/ }
    end
  end
end