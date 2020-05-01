
path = "../test_results/butterworth/";
lp = load([path "lp.txt"]);
bp = load([path "bp.txt"]);
hp = load([path "hp.txt"]);
bs = load([path "bs.txt"]);
bsdc = load([path "bsdc.txt"]);

fy = abs(fft(lp));
fx = linspace(0,250,length(lp));
subplot(2,2,1);
plot(fx, fy);
axis([ 0 125 0 1]);
title("Lowpass");
xlabel("f/Hz");
#
fy = abs(fft(hp));
fx = linspace(0,250,length(lp));
subplot(2,2,2);
plot(fx,fy);
axis([ 0 125 0 1]);
title("Highpass");
xlabel("f/Hz");
#
fy = abs(fft(bp));
fx = linspace(0,250,length(lp));
subplot(2,2,3);
plot(fx,fy);
axis([ 0 125 0 1]);
title("Bandpass");
label("f/Hz");
#
fy = abs(fft(bs));
fx = linspace(0,250,length(lp));
subplot(2,2,4);
plot(fx,fy);
axis([ 0 125 0 1]);
xlabel("f/Hz");
title("Bandstop");
#
print 'filtertest.png'

## Copyright (C) 2016 Bernd Porr
##
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{retval} =} filtertest (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Bernd Porr <bp1@bp1-Precision-WorkStation-T5400>
## Created: 2016-10-08

#path = "../test_results/butterworth/"
#load [path "lp.txt"]
#fy = abs(fft(lp));
#fx = linspace(0,250,length(lp));
#subplot(2,2,1);
#plot(fx,fy);
#axis([ 0 125 0 1]);
#title("Lowpass");
#xlabel("f/Hz");
#
#load [path "hp.txt"]
#fy = abs(fft(hp));
#fx = linspace(0,250,length(lp));
#subplot(2,2,2);
#plot(fx,fy);
#axis([ 0 125 0 1]);
#title("Highpass");
#xlabel("f/Hz");
#
#load [path "bp.txt"]
#fy = abs(fft(bp));
#fx = linspace(0,250,length(lp));
#àsubplot(2,2,3);
#plot(fx,fy);
#axis([ 0 125 0 1]);
#title("Bandpass");
#x#label("f/Hz");
#
#load [path "bs.txt"]
#fày = abs(fft(bs));
#fx = linspace(0,250,length(lp));
#subplot(2,2,4);
#plot(fx,fy);
#axis([ 0 125 0 1]);
#xlabel("f/Hz");
#title("Bandstop");
#
#print 'filtertest.png'