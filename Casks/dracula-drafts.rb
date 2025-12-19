cask "dracula-drafts" do
  version :latest
  sha256 :no_check

  tokens = token.split "-"
  id = "2Ak"

  app_name = tokens.last.capitalize
  mas_id = "1435957248"

  domain = "directory.get#{tokens.last}.com"
  url "https://#{domain}/t/#{id}",
      verified: domain
  name "Dracula for #{app_name}"
  desc "Dark theme for #{app_name}"
  homepage "https://#{tokens.first}theme.com/#{tokens.last}"

  domain = "com.agiletortoise.#{app_name}"
  library = Pathname "#{Dir.home}/Library"

  db, = library.glob "Group Containers/*.#{domain}/DraftStore.sqlite"
  table = "ZMANAGEDSTORAGE"
  zuuid = "HOMEBREW-THEME-#{tokens.first.upcase}"

  icloud = "Mobile Documents/iCloud~" + domain.tr(".", "~")
  themes = library.glob("#{icloud}[0-9]/Documents/Library/Themes").max
  themes ||= library/"#{icloud}5/Documents/Library/Themes"

  ext = "#{tokens.last}Theme"
  theme = "Dracula.#{ext}"

  artifact theme, target: themes/theme

  preflight do
    error = "#{app_name} is not installed. Try: mas install #{mas_id}"
    raise error unless (appdir/"#{app_name}.app").directory?

    require "csv"
    require "nokogiri"
    document = Nokogiri::HTML.parse staged_path/id

    handler = "x-drafts://importtheme?identifier=#{id}&data="
    a = document.at_css "a[href^='#{handler}']"
    theme = JSON.parse CGI.unescape(a[:href]).delete_prefix handler

    filter = %w[name identifier source]
    name, zkey, source = theme.values_at(*filter)
    index = theme.slice!(*filter)["sortIndex"]
    time = Time.now.to_f

    headers = %w[Z_ENT Z_OPT ZHIDDEN ZCREATED_AT ZMODIFIED_AT ZSORT_INDEX ZCHANGE_TAG ZKEY ZTYPE ZUUID ZVALUE]
    cells = [7, 2, 0, time, time, index, "brew", zkey, "customTheme", zuuid, theme.to_json]

    s = "'%s'," * 11
    command     =   "insert into  #{table} (#{headers.to_csv.chop}) values (#{s.chop})"
    command.prepend "create table #{table} (#{headers.to_csv.chop});" unless db.file?

    system "sqlite3", db, command % cells
    (staged_path/"#{name}.#{ext}").write source
    (staged_path/id).delete
  end

  uninstall_postflight do
    system "sqlite3", db, "delete from #{table} where ZUUID = '#{zuuid}'"
    themes.delete if themes.empty?
  end
end
