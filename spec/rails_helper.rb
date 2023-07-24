
# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
 Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

I18n.locale = "en"

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  
  config.include SignInSupport

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/6-0/rspec-rails
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

#2023/07/24結合テストエラーにより追加↓
  config.before(:each) do |example|
    if example.metadata[:type] == :system
      if example.metadata[:js]
        driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
      else
        driven_by :rack_test
      end
    end
  end
  # このコードはRSpecの設定（config）ブロック内に記述されており、RSpecのテスト実行時に各テスト（example）が実行される前に実行されるブロックです。
  # このブロックの中で、テストの種類（:type）とJavaScriptを含むかどうか（:js）に応じて、適切なドライバーを指定しています。RSpecには通常、Systemテスト（ブラウザを起動するテスト）と非Systemテスト（ブラウザを起動しないテスト）の2種類のテストがあります。それぞれに対して適切なドライバーを設定しています。
  
  # 解説すると以下のようになります：
  # config.before(:each) do |example|: 各テスト（example）が実行される前に、このブロックが実行されるようにRSpecに設定します。
  # if example.metadata[:type] == :system: テストの種類がSystemテストかどうかを判定します。:typeメタデータはRSpecがテストの種類を指定するために使用されるもので、Systemテストの場合には:systemがセットされます。
  # if example.metadata[:js]: テストにJavaScriptが含まれるかどうかを判定します。:jsメタデータはJavaScriptがテストに含まれるかどうかを指定するために使用されます。
  # driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]: SystemテストでJavaScriptを含む場合、Seleniumドライバーを使用してヘッドレスChromeでテストを実行します。ヘッドレスChromeはブラウザウィンドウを表示せずにテストを実行することができます。また、画面サイズを [1400, 1400] に指定しています。
  # driven_by :rack_test: Systemテストではない場合（通常のコントローラーなどのテスト）、代わりにRackTestドライバーを使用してテストを実行します。RackTestドライバーはブラウザを立ち上げずにテストを実行するドライバーです。
  # この設定ブロックにより、Systemテストと非Systemテストの両方をサポートするようにドライバーを適切に設定しています。SystemテストはJavaScriptなどのブラウザ側の動作を含む場合に使用され、非Systemテストはコントローラーやモデルのテストなど、ブラウザを立ち上げないテストに使用されます。


end

