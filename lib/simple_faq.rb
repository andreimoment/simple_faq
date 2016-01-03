require "simple_faq/version"
require 'simple_faq/engine' if defined?(Rails)
require "redcarpet"

module SimpleFAQ

      class Formatter

        REGEXES = {
          section_title: /(\{section-title\}([\s|\S|\n|\r]*?)\{\/section-title\})/i,
          intro: /\A([\s|\S]*?){/i,
          qa: /(\{q\}([\s\S]*?)\{\/q\}[\r\n|\n|\s]*?\{a\}([\s\S]*?)\{\/a\})/i,
          vimeo: /(\{\s*?vimeo\s*?:\s*?([0-9]*?)\s*?\})/i,
          has_video: /({[\s]*?vimeo\s*?:\s*?\d{5,10}\s*?})/i
        }

        MARKDOWN = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                    no_intra_emphasis: true, tables: true,
                    fenced_code_blocks: true, autolink: true,
                    strikethrough: true, highlight: true, quote: true)

        FORMATTING = {
          q: "<h3 class=\"faq--question\" data-qa=\"{i}\">{q}</h3>",
          q_with_video: "<h3 class=\"faq--question\" data-qa=\"{i}\">{q}<span class=\"with-video\"></span></h3>",
          a: "<div class=\"faq--answer answer-{i} hidden\">{a}</div>",
          vimeo: '<iframe src="//player.vimeo.com/video/{stream_id}?title=0&amp;byline=0&amp;portrait=0&amp;badge=0" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>',
          section_list: '<ul class="faq--section--list">{section-list}</ul>',
          title_anchor: "<h2 class=\"faq--section--title-anchor\"><a name=\"section-{i}\"></a>{title}</h2>",
          title_link: "<li class=\"faq--section--title-link\"><a href=\"#section-{i}\">{title}</a></li>",
          body_wrap: %Q{<div class="faq">{body}</div>}
        }

        def initialize(body)
          @body = body.strip.gsub("\r", "")
          @section_list = ""
          format_section_titles
          format_qa_pairs
          format_intro
          format_section_list
          @body.gsub!(/(\n){1,}/, "\n")
        end

        def html
          FORMATTING[:body_wrap].sub("{body}", @body)
        end

      private

        def format_section_list
          @body.gsub!('{section-list}', FORMATTING[:section_list].sub("{section-list}", @section_list))
        end

        def format_section_titles
          title_matches = @body.scan(REGEXES[:section_title])
          title_matches.each_with_index do |title_match, i|
            title_sub_string = title_match[0]
            title = title_match[1]

            title_anchor = FORMATTING[:title_anchor].gsub('{i}', i.to_s).gsub('{title}', title)
            title_link = FORMATTING[:title_link].gsub('{i}', i.to_s).gsub('{title}', title)

            @body.sub!(title_sub_string, title_anchor)
            @section_list << title_link
          end
        end

        def format_qa_pairs
          qas = @body.scan(REGEXES[:qa])
          qas.each_with_index do |qa_pair, qa_index|
            qa_sub_string = qa_pair[0]
            q = qa_pair[1]
            a = qa_pair[2]
            q_formatting = if a.match(REGEXES[:has_video])
              :q_with_video
            else
              :q
            end

            qa_id = "q#{qa_index}"

            a_with_markdown = MARKDOWN.render(a.strip)
            a_with_vimeo = process_vimeo_tags(a_with_markdown)

            q_formatted = FORMATTING[q_formatting].gsub('{q}', q.strip).gsub('{i}', qa_id)
            a_formatted = FORMATTING[:a].gsub('{a}', a_with_vimeo).gsub('{i}', qa_id)

            qa_html = q_formatted + "\n" + a_formatted

            @body.sub!(qa_sub_string, qa_html)
          end

        end

        def process_vimeo_tags s
          r = s.dup
          streams = s.scan(REGEXES[:vimeo])

          streams.each do |stream|
            stream_tag = stream[0]
            stream_id = stream[1]
            stream_html = FORMATTING[:vimeo].sub('{stream_id}', stream_id)
            r.sub!(stream_tag, stream_html)
          end
          r
        end

        def format_intro
          intro_tag_match = @body.scan(REGEXES[:intro]).flatten
          return unless intro_tag_match.size > 0

          intro_sub_string = intro_tag_match[0]
          intro_body = intro_sub_string.strip

          @body.sub!(intro_sub_string, MARKDOWN.render(intro_body))
        end

      end

end
