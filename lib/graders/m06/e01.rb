require_relative 'base'
require_relative 'e02'

module Graders
  module M06
    class E01 < Graders::M06::Base

      def check_solution_file_exists
        f = File.expand_path('m06-e01.rb', @work_dir)

        if File.exists?(f)
          mark_pass
          load f
          @exercises = MySQLExercises1.new
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_q_about_query_method
        qq = q[:special_queries][:q_about_query_method]

        expected = @exercises.client.query(qq).class
        actual   = @exercises.q_about_query_method

        if expected == actual
          mark_pass
        else
          mark_fail i18n_args: { actual_class: actual.inspect }
        end

      rescue => ex
        mark_fail(error: ex)
      end

      def check_q_how_many_tables
        qq = q[:special_queries][:q_how_many_tables]

        expected = @exercises.client.query(qq).entries.map { |x| x.values.first }
        actual   = @exercises.q_how_many_tables

        if expected.sort == actual.sort
          mark_pass
        else
          mark_fail i18n_args: { actual_tables: actual.inspect }
        end

      rescue => ex
        mark_fail(error: ex)
      end

      def check_q_title_data_type
        qq = q[:special_queries][:q_title_data_type]

        expected = @exercises.client.query(qq).entries.find { |e| e["Field"] == "title" }["Type"]
        actual   = @exercises.q_title_data_type

        if expected.to_s.downcase == actual.to_s.downcase
          mark_pass
        else
          mark_fail i18n_args: { actual_type: actual.inspect }
        end

      rescue => ex
        mark_fail(error: ex)
      end

      def check_q_categories_primary_key
        actual = @exercises.q_categories_primary_key

        if actual == 'id'
          mark_pass
        else
          mark_fail i18n_args: { actual: actual.inspect }
        end

      rescue => ex
        mark_fail(error: ex)
      end

      def check_q_reviews_foreign_keys
        actual = @exercises.q_reviews_foreign_keys

        if actual.sort == [ 'user_id', 'product_id'].sort
          mark_pass
        else
          mark_fail i18n_args: { actual: actual.inspect }
        end

      rescue => ex
        mark_fail(error: ex)
      end

      def check_queries_e01
        check_queries
      end

    end
  end
end
