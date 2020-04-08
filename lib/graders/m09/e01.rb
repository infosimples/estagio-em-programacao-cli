require 'mechanize'

module Graders
  module M09
    class E01 < Graders::Base
      HOST = 'epserver'
      PORT = 3000
      SAMPLE = rand(1000).to_s

      def run_tests
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end

        @test_name = 'final_check_delete_article'
        final_check_delete_article
      end

      def tests_count
        super + 1
      end

      def agent
        @agent ||= Mechanize.new
      end

      def check_rails_server
        begin
          agent.get "http://#{HOST}:#{PORT}/"
          mark_pass
        rescue Net::HTTP::Persistent::Error => error
          mark_fail
        rescue
          mark_pass
        end
      end

      def check_home_page
        agent.get "http://#{HOST}:#{PORT}/"
        if agent.page.body.match(/Yay! You.*re on Rails!/)
          mark_fail
        else
          mark_pass
        end
      rescue
        mark_fail
      end

      def check_create_article_home
        create_article
        agent.get "http://#{HOST}:#{PORT}/"

        if agent.page.body.index('_' + SAMPLE)
          mark_pass
        else
          mark_fail
        end
      rescue
        mark_fail
      end

      def check_create_article_page
        create_article

        agent.get "http://#{HOST}:#{PORT}/articles"
        id = agent.page.body.scan(/articles\/(\d+)/).flatten.map { |id| id.to_i }.max

        agent.get "http://#{HOST}:#{PORT}/artigo/#{id}"

        if agent.page.body.index('_' + SAMPLE)
          mark_pass
        else
          mark_fail
        end
      rescue
        mark_fail
      end

      def check_create_article_category
        create_article

        agent.get "http://#{HOST}:#{PORT}/categoria?c=CATEGORIA_#{SAMPLE}"

        if agent.page.body.index('_' + SAMPLE)
          mark_pass
        else
          mark_fail
        end
      rescue
        mark_fail
      end

      def check_view_count
        agent.get "http://#{HOST}:#{PORT}/articles"
        views = agent.page.body[/O blog teve (\d+) visitas/, 1].to_i

        agent.get "http://#{HOST}:#{PORT}/"

        agent.get "http://#{HOST}:#{PORT}/articles"
        views_after = agent.page.body[/O blog teve (\d+) visitas/, 1].to_i

        if views_after - views == 1
          mark_pass
        else
          mark_fail
        end
      end

      def final_check_delete_article
        agent.get "http://#{HOST}:#{PORT}/articles"
        id = agent.page.body.scan(/articles\/(\d+)/).flatten.map { |id| id.to_i }.max

        args = {
          '_method' => 'delete',
          'authenticity_token' => agent.page.body[/csrf-token" content="([^"]+)"/, 1]
        }
        agent.post "http://#{HOST}:#{PORT}/articles/#{id}", args

        agent.get "http://#{HOST}:#{PORT}/articles"
        old_id = id
        id = agent.page.body.scan(/articles\/(\d+)/).flatten.map { |id| id.to_i }.max

        if id != old_id
          mark_pass
        else
          mark_fail
        end
      rescue
        mark_fail
      end

      private

      def create_article
        return if @created_article
        @created_article = true
        agent.get "http://#{HOST}:#{PORT}/articles/new"

        form = agent.page.form_with(action: '/articles')

        form.fields.each do |field|
          form[field.name] = case field.name
          when /title/
            'TITULO_' + SAMPLE
          when /author/
            'AUTOR_' + SAMPLE
          when /category/
            'CATEGORIA_' + SAMPLE
          when /content/
            'CONTEUDO_' + SAMPLE
          end
        end

        form['authenticity_token'] = agent.page.body[/csrf-token" content="([^"]+)"/, 1]

        form.submit
      end


    end
  end
end
