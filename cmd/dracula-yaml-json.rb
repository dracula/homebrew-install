# frozen_string_literal: true

Homebrew.install_bundler_gems!
require "active_support/all"

String.define_method(:to_p) { Pathname self }

module Homebrew
  module_function

  $repo = "dracula/template"
  branch = "6f20086e12c202435d68f73f81e1df8af58bab67"
  $include = "#{branch}/Dracula.yml"

  def dracula_yaml_json_args
    CLI::Parser.new do
      description <<~EOS
        Simple command to convert source YAML to JSON. Dracula `*COLOR` aliases are available from
        anchors defined in the included `#{$include}` spec template:
          <https://github.com/#{$repo}/blob/#{$include}>

        JSON output will be <stdout> given <stdin>, else a file generated in the current directory,
        with name and extension based on the `name:` property, and last line of `.gitignore`.

        Specify multiple `.y`[`a`]`ml` files to be concatenated together in the given order as input.
      EOS

      flag "-i=", "--indent=", description: <<~EOS
        Specify JSON output indentation as either a string literal, or number of `space`s. A value
        of `1` will output `tab`s, while `0` will produce minified JSON. A `HOMEBREW_INDENT`
        environment variable can also be set.
      EOS

      named_args %i[stdin yaml], min: 0
    end
  end

  def dracula_yaml_json
    stdin = $stdin.ready? if ENV["GITHUB_ACTIONS"].blank?

    args = dracula_yaml_json_args.parse
    args.named.map!(&:to_p).filter!(&:file?)
    args.named.unshift $include.to_p.basename

    base = curl_output "https://raw.githubusercontent.com/#{$repo}/#{$include}"

    args.named.push $stdin if stdin
    base.stdout << args.named.map(&:read).join if args.named.first.file?

    theme = YAML.safe_load(base.stdout, aliases: true).with_indifferent_access
    theme = theme.dup.reduce(theme) do |hash, (key, value)|
      yield hash, [key, value]
      next  hash
    end if block_given?
    theme.delete :spec
    theme.deep_transform_values! do |value|
      value.dup.prepend "#" if value.to_s.match? /^(\h{3}){1,2}/
      next value
    end

    i = args.indent.to_i || ENV["HOMEBREW_INDENT"].to_i || 2
    indent = case i
    when 2.. then " " * i
    when 1   then "\t"
    else json = theme.to_json
    end if indent.present?

    json ||= JSON.pretty_generate theme, indent: indent
    return puts json if stdin

    name = theme.fetch :name, args.named.first.basename(".*").to_s.titlecase
    gitignore = Pathname  ".gitignore"
    ext = gitignore.file? ? gitignore.readlines.last.chomp.to_p.extname : ".json"

    (args.named.first.dirname/name).sub_ext(ext).write json
  end
end
