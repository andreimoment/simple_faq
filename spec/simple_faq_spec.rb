require 'spec_helper'

describe SimpleFAQ::Formatter do

  let(:input) { "the body" }
  let(:ff) { SimpleFAQ::Formatter.new(input) }

  it 'may be initialized' do
    expect(ff).to be_a SimpleFAQ::Formatter
  end

  it "returns body text passed as the body" do
    expect(ff.html.scan('the body').size).to eq 1
  end

  context 'with a FAQ definition' do
    let(:input) { TEST_DATA }

    it "creates the first section title with an anchor tag" do
      expect(ff.html.scan('<h2 class="faq--section--title-anchor"><a name="section-0"></a>Section 1</h2>').size).to eq 1
    end

    it "creates the second section title with an anchor tag" do
      expect(ff.html.scan('<h2 class="faq--section--title-anchor"><a name="section-1"></a>Section 2</h2>').size).to eq 1
    end

    it "creates a section list" do
      expect(ff.html.scan('<li class="faq--section--title-link"><a href="#section-0">Section 1</a></li>').size).to eq 1
      expect(ff.html.scan('<li class="faq--section--title-link"><a href="#section-1">Section 2</a></li>').size).to eq 1
    end

    it "creates the questions" do
      expect(ff.html.scan('<h3 class="faq--question" data-qa="q0">How do I add single line spacing?</h3>').size).to eq 1
      expect(ff.html.scan('<h3 class="faq--question" data-qa="q1">How do I add normal (paragraph) line spacing?</h3>').size).to eq 1
    end

    it "creates the answer sections" do
      expect(ff.html.scan('<div class="faq--answer answer-q0 hidden">').size).to eq 1
      expect(ff.html.scan('<div class="faq--answer answer-q1 hidden">').size).to eq 1
      expect(ff.html.scan('<div class="faq--answer answer-q2 hidden">').size).to eq 1
      expect(ff.html.scan('<div class="faq--answer answer-q3 hidden">').size).to eq 1
    end

    it "creates answers" do
      expect(ff.html.scan("<div class=\"faq--answer answer-q0 hidden\"><p>Press Ctrl+Enter instead of Enter</p>\n</div>").size).to eq 1
    end

    it "creates video streams in iframes" do
      expect(ff.html.scan('<iframe src="//player.vimeo.com/video/11663853?title=0&amp;byline=0&amp;portrait=0&amp;badge=0" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>').size).to eq 1
      expect(ff.html.scan('<iframe src="//player.vimeo.com/video/23607676?title=0&amp;byline=0&amp;portrait=0&amp;badge=0" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>').size).to eq 1
    end

    it 'creates video badge (via css) for questions with video' do
      expect(ff.html.scan("<h3 class=\"faq--question\" data-qa=\"q5\">I would like some more kittens, this time with close-ups!<span class=\"with-video\">").size).to eq 1
      expect(ff.html.scan("<span class=\"with-video\">").size).to eq 2
    end

    it "creates the intro content, Markdown-formatted" do
      expect(ff.html.scan('<h1>Intro Headline</h1>').size).to eq 1
    end

  end

end