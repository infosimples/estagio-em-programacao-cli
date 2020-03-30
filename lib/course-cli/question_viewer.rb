module CourseCli
  class QuestionViewer
    def self.view(file)
      if (host = %x{echo $C9_HOSTNAME}.strip).size > 0
        Cloud9Viewer.view(host, file)
      elsif %x{uname}[/darwin/i]
        CommandViewer.view('open', file)
      elsif  %x{which sensible-browser}.size > 0
        CommandViewer.view('sensible-browser', file)
      else
        raise I18n.t('cli.errors.os_unsupported')
      end
    end

    class CommandViewer
      def self.view(cmd, file)
        %x{#{cmd} file://#{file}}
      end
    end

    class Cloud9Viewer
      def self.view(host, file)
        pid_file = File.join(PathHelper.install_dir, 'pids', 'server.pid')
        if File.exist?(pid_file)
          pid = File.read(pid_file)
          begin
            Process.kill(9, pid.to_i)
          rescue Errno::ESRCH
          end
        end

        pid = Process.fork
        if pid.nil?
          require 'webrick'
          STDOUT.reopen(File.open(File.join(PathHelper.log_dir, 'webrick.log'), 'a+'))
          STDERR.reopen(File.open(File.join(PathHelper.log_dir, 'webrick.log'), 'a+'))
          s = WEBrick::HTTPServer.new(Port: 8082, DocumentRoot: PathHelper.public_dir, BindAddress: '0.0.0.0')
          s.start
        else
          File.open(pid_file, 'w') do |f|
            f.write(pid)
          end
          Process.detach(pid)
          host = %x{echo $C9_HOSTNAME}.strip
          puts "O enunciado encontra-se em: http://#{host}:8082/#{File.basename(file)}"
        end
      end
    end

  end
end
