#!/usr/bin/perl

# Copyright 2015 Michael Fayad
#
# This file is part of mifay/postman.
#
# This file is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;
use utf8;
use Encode;
use MIME::Base64;
use Net::SMTP::TLS;

open LecteurDeFichier,"<input.txt" or die "E/S : $!\n";

while (my $Ligne = <LecteurDeFichier>)
{
   if($Ligne =~ /((\w|\.)+@(\w|\.)+)/)
   {
      print "$1\n";
      
      my $mailer = new Net::SMTP::TLS(
	      'smtp.gmail.com',
	      Hello   =>      'smtp.gmail.com',
	      Port    =>      587,
	      User    =>      'my_gmail_user',
	      Password=>      'my_gmail_password');
      $mailer->mail('my_gmail_user@gmail.com');
      $mailer->to($1);
      $mailer->data;

      my $mail_headers = "To: $1\n".
      "From: my_gmail_user\@gmail.com\n".
      "Subject: Message Subject\n".
      "MIME-Version: 1.0\n".
      "Content-type: text/plain; charset=UTF-8\n".
      "Content-Transfer-Encoding: base64\n\n";

      $mailer->datasend($mail_headers);

      # Line break to separate headers from body
      $mailer->datasend("\n");

      my $mail_body = "Message body.";
      $mailer->datasend(encode_base64(encode('utf8',$mail_body)));
      $mailer->dataend;
      $mailer->quit;
   }
}

close LecteurDeFichier;
