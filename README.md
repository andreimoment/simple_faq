# FAQFormat

FAQs may contain multiple sections with groups of questions and answers, which may get hard to maintain in HTML format.

FAQFormat simplifies the creation of interactive FAQ documents using Markdown and a few special tags. The document

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_faq'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_faq


### CSS and JS Assets

If you are using this as a Rails gem, require the gem assets:

~~~
// app/assets/javascripts/application.js:
//= require simple_faq

// app/assets/stylesheets/application.css:
*= require simple_faq
~~~

If you are not using rails, copy the assets files manually.

## Usage

~~~
html_for_display = SimpleFAQ::Formatter.new(markdown_with_faq_tags).html
~~~

### FAQ Tags:

Question and answer tag pairs work together:

    {q}Question title{/q}   <= will display the title as a link
    {a}Answer content{/a}   <= clicking the title (above) of this question
                               will expand/collapse its answer

and may be displayed in sections:

    {section-list}     <= will display a list of section titles,
                          each linking to the corresponding section
                          down the page

    {section-title}Section 1{/section-title}
    {q}Question title{/q}
    {a}Answer content{/a}

    {section-title}Section 2{/section-title}
    {q}Question title{/q}
    {a}Answer content{/a}


### Example:

In a Rails view:

    <%

    faq_content = %Q{
    #Intro Headline

    {section-list}

    {section-title}Section 1{/section-title}

    {q}How do I create a new paragraph in HTML?{/q}
    {a}
    Use the `p` tag:

    ~~~
    <p>Paragraph</p>
    ~~~
    {/a}

    {q}Can you help me feel better?{/q}
    {a}Take a short walk, that almost always helps. If you are thirsty or hungry, have some water or food. If you're tired, rest for a bit.

    ### Or, watch some kittens.

    {vimeo:11663853}
    {/a}

    {section-title}Section 2{/section-title}

    {q}Section 2 Q1{/q}
    {a}Section 2 A1{/a}

    {q}I would like some more kittens, this time with close-ups!{/q}
    {a}
    Here you go:

    {vimeo:23607676}
    {/a}
    }

    formatted_faq_content = SimpleFAQ::Formatter.new(faq_content).html

    %>

    <%= formatted_faq_content.html_safe %>

 In a real applicatoin, you may want to have the faq content in a database and prepare the formatted_faq_content in the model.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/faq_format/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
