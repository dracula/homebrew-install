# typed: strict
# frozen_string_literal: true

require_relative "../lib/utils"

CASE = {
  upper:      "upcase",
  lower:      "downcase",
  title:      "titlecase",
  capitalize: "capitalize",
  capitalise: "capitalize",
}.freeze

REPO     = "dracula/template"
COMMIT   = "291aa546dbf6e95ba4eabec737df8d348125c379"
path     = "sample/Dracula.yml"
TEMPLATE = path.to_p.freeze

module Homebrew
  module Cmd
    # dracula-yaml-json
    class DraculaYamlJson < AbstractCommand
      cmd_args do
        description <<~EOS
          Simple command to convert source YAML to JSON. Dracula `*COLOR` aliases are available from
          anchors defined in the included `#{TEMPLATE.basename}` spec template:
            <https://github.com/#{REPO}/blob/#{COMMIT}/#{TEMPLATE}>

          JSON output will be <stdout> given <stdin>, else a file generated in the current directory,
          with name and extension based on the `name:` property, and last line of `.gitignore`.

          Specify multiple `.y`[`a`]`ml` files to be concatenated together in the given order as input.
        EOS

        comma_array "--exclude", description: "Supply a CSV list of source colors to exclude from the output."

        flag "-c=", "--case=",
             description: "Output keys as `upper`, `lower`, `title`case, or `capitalize`d."

        flag "-t=", "--tabsize=", "--indent=", description: <<~EOS
          Specify output indentation as number of spaces. A value of `1` will
          output `tab`s, while `0` will produce minified JSON. `2` spaces is the default.
          Alternatively, the `HOMEBREW_TABSIZE` environment variable will be respected.
        EOS

        switch "-y", "--yaml", "--yml", description: "Output raw YAML template source."

        flag "-o=", "--output=", description: "Output file path, or `-` for stdout."

        named_args [:stdin, :yaml], min: 0
      end

      def run
        require "yaml"
        require "io/wait"
        stdin = $stdin.ready? if ENV["GITHUB_ACTIONS"].blank?

        args.named.map!(&:to_p).filter! &:file?
        args.named.unshift TEMPLATE.basename

        yaml = Utils::Curl.curl_output "https://raw.githubusercontent.com/#{REPO}/#{COMMIT}/#{TEMPLATE}"
        return puts yaml.stdout if args.yaml?

        args.named.push $stdin if stdin
        yaml.stdout << args.named.map(&:read).join if args.named.first.file?

        template = YAML.safe_load yaml.stdout, aliases: true, symbolize_names: true
        theme = template.fetch :spec, {}

        if block_given?
          theme = theme.dup.reduce(theme) do |hash, (key, value)|
            yield hash, [key, value]
            next  hash
          end
        else
          theme.transform_keys! &:to_s
          theme.delete_if { args.exclude&.include? _1 }

          if args.case.present?
            theme.transform_keys! do |key|
              next key.gsub(/[_\W]+/, " ").send CASE[args.case.to_sym]
            end
          end
          theme.transform_values! do |value|
            value.prepend "#" if value.match?(/^(\h{3}){1,2}/)
            next value.upcase
          end
        end

        i = args.indent&.to_i || ENV["HOMEBREW_TABSIZE"]&.to_i || 2
        indent = case i
        when 2.. then " " * i
        when 1   then "\t"
        else json = theme.to_json
        end

        json ||= JSON.pretty_generate theme, indent: indent
        return puts json if stdin || args.output == "-"

        name = template.fetch "name", args.named.first.basename(".*").to_s.titlecase
        gitignore = Pathname ".gitignore"
        ext = gitignore.file? ? gitignore.readlines.last.chomp.to_p.extname : ".json"

        file = args.output&.to_p || (args.named.first.dirname/name).sub_ext(ext)
        file.write json
      end
    end
  end
end
