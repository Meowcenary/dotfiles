#!/usr/bin/env ruby

require 'rubygems'
require 'optiflag'
require 'readline'

# See http://optiflag.rubyforge.org/example_1.html
module Example extend OptiFlagSet
  character_flag :q, :verbosity
  character_flag :s, :verbosity
  character_flag :k, :speed
  character_flag :p, :production
  character_flag :d, :dryrun

  character_flag :q do
    description "Quiet, minimal output"
  end
  character_flag :s do
    description "Silent, zero normal output"
  end
  character_flag :k do
    description "Quick, sync only without further steps"
  end
  character_flag :p do
    description "Production, sync to production server instead of staging"
  end
  character_flag :d do
    description "Dry-run, don't actually transmit data"
  end
  and_process!
end

SILENT = ARGV.flags.s?
QUIET  = ARGV.flags.q? || SILENT
QUICK  = ARGV.flags.k?
PROD   = ARGV.flags.p?
DRY    = ARGV.flags.d?

DIR_TO_SYNC = "#{File.expand_path File.dirname(__FILE__)}/../"

# Production mode gets some safeguards
if PROD && !DRY
  print "For 'production' mode you must confirm by typing 'yes' in all caps: "
  confirmation = Readline.readline
  if confirmation!='YES'
    puts "Aborting!"
    exit 1
  end
end

puts "Rsync..." unless SILENT
if PROD
  #host can be an ip or server name
  #e.g prod.site.com
  host=''
  port='22'
  user=''
  #-i #{ENV['HOME']}/.ssh/<your pem file>
  ssh_opts=""
  #full path to destination directory
  #e.g '/var/www/sites/test_site'
  dest=''
  puts "PRODUCTION" unless SILENT
else
  #same deal but for another environment
  host=''
  port='22'
  user=''
  ssh_opts=''
  dest=''
  puts "STAGING" unless SILENT
end

bin = "/usr/bin/rsync "
args=<<EOF
--compress \
--rsh="ssh #{ssh_opts} -p #{port}" \
--itemize-changes \
--checksum \
--recursive \
--links \
--delete \
--exclude '.powrc' \
--exclude '.idea' \
--exclude '.powenv' \
--exclude '.git' \
--exclude '.svn' \
--exclude '.DS_Store' \
--exclude '*.log' \
--exclude '.loadpath' \
--exclude '.subproject' \
--exclude 'tmp' \
--exclude 'coverage' \
--exclude 'log' \
--exclude 'local' \
--exclude 'app/assets/media' \
--exclude 'public/cache' \
--exclude 'public/websites' \
--exclude 'public/mobile_uploads' \
--exclude 'public/refile' \
--exclude 'public/uploads' \
--exclude 'public/system' \
--exclude 'public/system/avatars' \
--exclude 'db/sphinx' \
--exclude '.rvmrc' \
--exclude 'public/assets' \
--progress \
#{DIR_TO_SYNC} #{user}@#{host}:#{dest}
EOF

# --exclude 'app/assets/swfs' \

command = bin
command += "--dry-run " if DRY
command += args
stdout = system(command)
puts stdout unless QUIET
