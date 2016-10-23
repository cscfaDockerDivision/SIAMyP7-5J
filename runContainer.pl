#!/usr/bin/perl

use Getopt::Long;

my $source = '';
my $host = '';
my $ip = '';
my $image = '';
my $verbose = '';
my $net = '';
my $help = '';
my $noSource = '';
my $noIp = '';

GetOptions (
	"source=s"  => \$source,
	"host=s"    => \$host,
	"ip=s"	    => \$ip,
	"image=s"   => \$image,
	"net=s"     => \$net,
	"no-source" => \$noSource,
	"no-ip" => \$noIp,
	"verbose"   => \$verbose,
	"help"      => \$help
) or die ("Error in command line arguments. Use --help option to display help.");

sub help{
	
  print "\nUsage: $0 --source=string --host=string --ip=string --image=string [--net=string] [--verbose|-v] [--help|-h]\n";
  print "\t--source|-s :\tThe path to the local jenkins/mysql to be mounted into the container\n";
  print "\t--host :\tThe server name of the container\n";
  print "\t--ip :\t\tThe container ip\n";
  print "\t--image :\tThe docker image name to run\n";
  print "\t--net :\tThe docker network to use\n";
  print "\t--no-source :\tDisable external volume\n";
  print "\t--no-ip :\tDisable network ip setting\n";
  print "\t--verbose-v :\tDisplay more informations\n";
  print "\t--help :\tDisplay this help\n\n";
}

if($help){
	help();
	exit 0;
}

if($verbose){
	print "Given arguments :\n";
	print "source : \t'$source' \n";
	print "host : \t\t'$host' \n";
	print "ip : \t\t'$ip' \n";
	print "image : \t'$image' \n";
	
	if($net){
		print "net : \t\t'$net' \n";
	}
}

sub checkValue{
	die "Argument count error for subroutine checkValue" unless @_ == 2;
	my ($value, $name) = @_;
	if(!$value){
		print "\n$name must be defined\n\n";
		help();
		exit 2;
	}
}

sub checkNetwork{
	die "Argument count error for subroutine checkNetwork" unless @_ == 1;
	my ($network) = @_;
	my $networks = `docker network ls`;
	
	if(!($networks =~ / $net /)){
		print "\nDocker network '$network' does not exist. Existing are : \n";
		print $networks;
		print "For help see https://docs.docker.com/engine/reference/commandline/network_create/\n";
		exit 3;
	}
}

sub checkImage{
	die "Argument count error for subroutine checkImage" unless @_ == 1;
	my ($image) = @_;
	my $images = `docker images`;
	
	if(!($images =~ /\n$image /)){
		print "\nDocker image '$image' does not exist. Existing are : \n";
		print $images;
		print "For help see https://docs.docker.com/engine/reference/commandline/build/\n";
		exit 4;
	}
}

if(!$noSource){
	checkValue($source, "Volume source");
}
checkValue($host, "Container host name");
checkValue($ip, "Container ip");
checkValue($image, "Docker image name");

checkImage($image);

if($net){
	checkNetwork($net);
}

my $comVolume = "";
if(!$noSource){
	$comVolume = "-v $source:/mnt/hostShared";
}
my $comHost = "--add-host=$host:$ip";

my $comNet="";
if($net){
	$comNet = " --net $net";
	if(!$noIp){
		$comNet = $comNet . " --ip $ip";
	}
}

my $container = `docker run$comNet -td $comVolume $comHost $image`;

print $container;
exit 0;
