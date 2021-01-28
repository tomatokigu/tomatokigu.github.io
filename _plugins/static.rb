module Jekyll
	class StaticTag < Liquid::Tag
		def initialize(tag_name, markup, tokens)
			super
			@path = markup.strip
		end

		def lookup(context, name)
			lookup = context
			name.split(".").each { |value| lookup = lookup[value] }
			lookup
		end

		def render(context)
	        @path = Liquid::Template.parse(@path).render(context)

	        static = ""
			baseurl = lookup(context, 'site.baseurl')
			static_files = lookup(context, 'site.static_files')
			static_files.each { |file|
				if @path == file.relative_path
					path = file.relative_path
					time = file.modified_time.to_time.to_i
					static = "#{baseurl}#{path}?#{time}"
				end
			}
			static
		end
	end
end

Liquid::Template.register_tag('static', Jekyll::StaticTag)
