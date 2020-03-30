module CourseCli
  ##
  # Analytics
  class Analytics
    ##
    # Record an event of type 'command'.
    #
    def self.record_command(global, command, options, args)
      global_opts = global.select { |k, _| k.is_a?(Symbol) }
      command = command.name
      command_opts = options.select { |k, _| k.is_a?(Symbol) }

      log_args = {
        type: :command,
        data: {
          command: command,
          global_opts: global_opts,
          command_opts: command_opts,
          args: args
        }
      }

      record(log_args)
    end

    ##
    # Record an event of type 'error'.
    #
    def self.record_error(ex)
      lines = ex.backtrace.select { |line| line[PathHelper.root] }
      log_args = {
        type: :error,
        data: {
          class: ex.class,
          message: ex.message,
          backtrace: lines
        }
      }

      CourseCli.logger.error(log_args)
      record_api(log_args)
    end

    ##
    # Record an event of type 'grading'.
    #
    def self.record_grading(mod, exercise, solution_file, summary)
      solution = if solution_file && File.file?(solution_file)
        File.read(solution_file)
      end

      log_args = {
        type: :grading,
        data: {
          module: mod,
          exercise: exercise,
          solution: solution,
          summary: summary
        }
      }

      record(log_args)
    end

    def self.record(args)
      CourseCli.logger.debug(args)
      record_api(args)
    end

    def self.record_api(args)
      fork do
        begin
          # The event may have happened before the student has configured the
          # CLI. In this case, we're not interested in it.
          if UserConfig.student_code
            EP::API.post(:events, args.merge(student_code: UserConfig.student_code))
          end
        rescue => ex
          lines = ex.backtrace.select { |line| line[PathHelper.root] }
          message = if ex.respond_to?(:response)
                      "#{ex.message} - #{ex.response}"
                    else
                      ex.message
                    end

          CourseCli.logger.error(
            type: :error,
            data: {
              class: ex.class,
              message: message,
              backtrace: lines
            }
          )
        end
      end
    end
  end
end
