unit easing;

(*

//  original file header with copyright
//  easing.c
//
//  Copyright (c) 2011, Auerhaus Development, LLC
//
//  This program is free software. It comes without any warranty, to
//  the extent permitted by applicable law. You can redistribute it
//  and/or modify it under the terms of the Do What The Fuck You Want
//  To Public License, Version 2, as published by Sam Hocevar. See
//  http://sam.zoy.org/wtfpl/COPYING for more details.
//

   this unit is an pascal translation of easing.c
   see https://github.com/warrenm/AHEasing

   it's purpose is to calculate "smooth" animations from an source position to
   an destination over time. the easing function takes one parameter "time" where
   time = 0 = source/start position and time = 1 = destination position. the
   parts between will be calculated depending on the used function.

   Michael Laessig (fliegermichl)
   2020-05-03
*)

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils;

type
  AHFloat = type single;

  // the following declarations are specific for the pascal translation implementation
  TEasingFunction = function(p: AHFloat) : AHFloat;

  TEasingCurveType = (
   ctLinearInterpolation,
   ctQuadratic,
   ctCubic,
   ctQuartic,
   ctQuintic,
   ctSine,
   ctCircular,
   ctExponential,
   ctElastic,
   ctBack,
   ctBounce
  );

  TEasingMode = (
   emIn,
   emOut,
   emInout
  );

function GetEasingFunction(Mode : TEasingMode; CurveType : TEasingCurveType) : TEasingFunction;
function LinearInterpolation(p: AHFloat) : AHFloat;
function QuadraticEaseIn(p: AHFloat) : AHFloat;
function QuadraticEaseOut(p: AHFloat) : AHFloat;
function QuadraticEaseInOut(p: AHFloat) : AHFloat;
function CubicEaseIn(p: AHFloat) : AHFloat;
function CubicEaseOut(p: AHFloat) : AHFloat;
function CubicEaseInOut(p: AHFloat) : AHFloat;
function QuarticEaseIn(p : AHFloat) : AHFloat;
function QuarticEaseOut(p: AHFloat) : AHFloat;
function QuarticEaseInOut(p: AHFloat) : AHFloat;
function QuinticEaseIn(p: AHFloat) : AHFloat;
function QuinticEaseOut(p: AHFloat) : AHFloat;
function QuinticEaseInOut(p: AHFloat) : AHFloat;
function SineEaseIn(p: AHFloat) : AHFloat;
function SineEaseOut(p: AHFloat) : AHFloat;
function SineEaseInOut(p: AHFloat) : AHFloat;
function CircularEaseIn(p: AHFloat) : AHFloat;
function CircularEaseOut(p: AHFloat) : AHFloat;
function CircularEaseInOut(p: AHFloat) : AHFloat;
function ExponentialEaseIn(p: AHFloat) : AHFloat;
function ExponentialEaseOut(p: AHFloat) : AHFloat;
function ExponentialEaseInOut(p: AHFloat) : AHFloat;
function ElasticEaseIn(p: AHFloat) : AHFloat;
function ElasticEaseOut(p: AHFloat) : AHFloat;
function ElasticEaseInOut(p: AHFloat) : AHFloat;
function BackEaseIn(p: AHFloat) : AHFloat;
function BackEaseOut(p: AHFloat) : AHFloat;
function BackEaseInOut(p: AHFloat) : AHFloat;
function BounceEaseIn(p: AHFloat) : AHFloat;
function BounceEaseOut(p: AHFloat) : AHFloat;
function BounceEaseInOut(p: AHFloat) : AHFloat;

implementation
uses math;

const M_PI = PI;
      M_PI_2 = M_PI / 2;

function GetEasingFunction(Mode: TEasingMode; CurveType: TEasingCurveType
  ): TEasingFunction;
begin
  case CurveType of
   ctLinearInterpolation : Result := @LinearInterpolation;
   ctQuadratic : case Mode of
                   emIn  : Result := @QuadraticEaseIn;
                   emOut : Result := @QuadraticEaseOut;
                   emInOut : Result := @QuadraticEaseInOut;
                 end;
   ctCubic     : case Mode of
                   emIn  : Result := @CubicEaseIn;
                   emOut : Result := @CubicEaseOut;
                   emInOut : Result := @CubicEaseInOut;
                 end;
   ctQuartic   : case Mode of
                   emIn  : Result := @QuarticEaseIn;
                   emOut : Result := @QuarticEaseOut;
                   emInOut : Result := @QuarticEaseInOut;
                 end;
   ctQuintic   : case Mode of
                   emIn  : Result := @QuinticEaseIn;
                   emOut : Result := @QuinticEaseOut;
                   emInOut : Result := @QuinticEaseInOut;
                 end;
   ctSine      : case Mode of
                   emIn  : Result := @SineEaseIn;
                   emOut : Result := @SineEaseOut;
                   emInOut : Result := @SineEaseInOut;
                 end;
   ctCircular  : case Mode of
                   emIn  : Result := @CircularEaseIn;
                   emOut : Result := @CircularEaseOut;
                   emInOut : Result := @CircularEaseInOut;
                 end;
   ctExponential : case Mode of
                   emIn  : Result := @ExponentialEaseIn;
                   emOut : Result := @ExponentialEaseOut;
                   emInOut : Result := @ExponentialEaseInOut;
                 end;
   ctElastic   : case Mode of
                   emIn  : Result := @ElasticEaseIn;
                   emOut : Result := @ElasticEaseOut;
                   emInOut : Result := @ElasticEaseInOut;
                 end;
   ctBack        : case Mode of
                   emIn  : Result := @BackEaseIn;
                   emOut : Result := @BackEaseOut;
                   emInOut : Result := @BackEaseInOut;
                 end;
   ctBounce      : case Mode of
                   emIn  : Result := @BounceEaseIn;
                   emOut : Result := @BounceEaseOut;
                   emInOut : Result := @BounceEaseInOut;
                 end;
  end;
end;

// Modeled after the line y = x
function LinearInterpolation(p: AHFloat) : AHFloat;
begin
	result := p;
end;

// Modeled after the parabola y = x^2
function QuadraticEaseIn(p: AHFloat) : AHFloat;
begin
	result := p * p;
end;

// Modeled after the parabola y = -x^2 + 2x
function QuadraticEaseOut(p: AHFloat) : AHFloat;
begin
	result := -(p * (p - 2));
end;

// Modeled after the piecewise quadratic
// y = (1/2)((2x)^2)             ; [0, 0.5)
// y = -(1/2)((2x-1)*(2x-3) - 1) ; [0.5, 1]
function QuadraticEaseInOut(p: AHFloat) : AHFloat;
begin
	if(p < 0.5) then
		result := 2 * p * p
	else
		result := (-2 * p * p) + (4 * p) - 1;
end;

// Modeled after the cubic y = x^3
function CubicEaseIn(p: AHFloat) : AHFloat;
begin
	result := p * p * p;
end;

// Modeled after the cubic y = (x - 1)^3 + 1
function CubicEaseOut(p: AHFloat) : AHFloat;
var f : AHFloat;
begin
	f := (p - 1);
	result := f * f * f + 1;
end;

// Modeled after the piecewise cubic
// y = (1/2)((2x)^3)       ; [0, 0.5)
// y = (1/2)((2x-2)^3 + 2) ; [0.5, 1]
function CubicEaseInOut(p: AHFloat) : AHFloat;
var f : AHFloat;
begin
	if(p < 0.5) then
		result := 4 * p * p * p
	else
	begin
		f := ((2 * p) - 2);
		result := 0.5 * f * f * f + 1;
	end;
end;

// Modeled after the quartic x^4
function QuarticEaseIn(p : AHFloat) : AHFloat;
begin
	result := p * p * p * p;
end;

// Modeled after the quartic y = 1 - (x - 1)^4
function QuarticEaseOut(p: AHFloat) : AHFloat;
var f : AHFloat;
begin
	f := (p - 1);
	result := f * f * f * (1 - p) + 1;
end;

// Modeled after the piecewise quartic
// y = (1/2)((2x)^4)        ; [0, 0.5)
// y = -(1/2)((2x-2)^4 - 2) ; [0.5, 1]
function QuarticEaseInOut(p: AHFloat) : AHFloat;
var f : AHFloat;
begin
	if(p < 0.5) then
		result := 8 * p * p * p * p
	else
	begin
		f := (p - 1);
		result := -8 * f * f * f * f + 1;
	end;
end;

// Modeled after the quintic y = x^5
function QuinticEaseIn(p: AHFloat) : AHFloat;
begin
	result := p * p * p * p * p;
end;

// Modeled after the quintic y = (x - 1)^5 + 1
function QuinticEaseOut(p: AHFloat) : AHFloat;
var f : AHFloat;
begin
	f := (p - 1);
	result := f * f * f * f * f + 1;
end;

// Modeled after the piecewise quintic
// y = (1/2)((2x)^5)       ; [0, 0.5)
// y = (1/2)((2x-2)^5 + 2) ; [0.5, 1]
function QuinticEaseInOut(p: AHFloat) : AHFloat;
var f : AHFloat;
begin
	if(p < 0.5) then
		result := 16 * p * p * p * p * p
	else
	begin
		f := ((2 * p) - 2);
		result := 0.5 * f * f * f * f * f + 1;
	end;
end;

// Modeled after quarter-cycle of sine wave
function SineEaseIn(p: AHFloat) : AHFloat;
begin
	result := sin((p - 1) * M_PI_2) + 1;
end;

// Modeled after quarter-cycle of sine wave (different phase)
function SineEaseOut(p: AHFloat) : AHFloat;
begin
	result := sin(p * M_PI_2);
end;

// Modeled after half sine wave
function SineEaseInOut(p: AHFloat) : AHFloat;
begin
	result := 0.5 * (1 - cos(p * M_PI));
end;

// Modeled after shifted quadrant IV of unit circle
function CircularEaseIn(p: AHFloat) : AHFloat;
begin
	result := 1 - sqrt(1 - (p * p));
end;

// Modeled after shifted quadrant II of unit circle
function CircularEaseOut(p: AHFloat) : AHFloat;
begin
	result := sqrt((2 - p) * p);
end;

// Modeled after the piecewise circular function
// y = (1/2)(1 - sqrt(1 - 4x^2))           ; [0, 0.5)
// y = (1/2)(sqrt(-(2x - 3)*(2x - 1)) + 1) ; [0.5, 1]
function CircularEaseInOut(p: AHFloat) : AHFloat;
begin
	if(p < 0.5) then
		result := 0.5 * (1 - sqrt(1 - 4 * (p * p)))
	else
		result := 0.5 * (sqrt(-((2 * p) - 3) * ((2 * p) - 1)) + 1);
end;

// Modeled after the exponential function y = 2^(10(x - 1))
function ExponentialEaseIn(p: AHFloat) : AHFloat;
begin
	if (p = 0.0) then
           result := p
        else
           result := power(2, 10 * (p - 1));
end;

// Modeled after the exponential function y = -2^(-10x) + 1
function ExponentialEaseOut(p: AHFloat) : AHFloat;
begin
	if (p = 1.0) then
                result := p
        else
                result := 1 - power(2, -10 * p);
end;

// Modeled after the piecewise exponential
// y = (1/2)2^(10(2x - 1))         ; [0,0.5)
// y = -(1/2)*2^(-10(2x - 1))) + 1 ; [0.5,1]
function ExponentialEaseInOut(p: AHFloat) : AHFloat;
begin
	if ((p = 0.0) or (p = 1.0)) then
                result := p
        else
	if(p < 0.5) then
		result := 0.5 * power(2, (20 * p) - 10)
	else
		result := -0.5 * power(2, (-20 * p) + 10) + 1;
end;

// Modeled after the damped sine wave y = sin(13pi/2*x)*pow(2, 10 * (x - 1))
function ElasticEaseIn(p: AHFloat) : AHFloat;
begin
	result := sin(13 * M_PI_2 * p) * power(2, 10 * (p - 1));
end;

// Modeled after the damped sine wave y = sin(-13pi/2*(x + 1))*pow(2, -10x) + 1
function ElasticEaseOut(p: AHFloat) : AHFloat;
begin
	result := sin(-13 * M_PI_2 * (p + 1)) * power(2, -10 * p) + 1;
end;

// Modeled after the piecewise exponentially-damped sine wave:
// y = (1/2)*sin(13pi/2*(2*x))*pow(2, 10 * ((2*x) - 1))      ; [0,0.5)
// y = (1/2)*(sin(-13pi/2*((2x-1)+1))*pow(2,-10(2*x-1)) + 2) ; [0.5, 1]
function ElasticEaseInOut(p: AHFloat) : AHFloat;
begin
	if (p < 0.5) then
		result := 0.5 * sin(13 * M_PI_2 * (2 * p)) * power(2, 10 * ((2 * p) - 1))
	else
		result := 0.5 * (sin(-13 * M_PI_2 * ((2 * p - 1) + 1)) * power(2, -10 * (2 * p - 1)) + 2);
end;

// Modeled after the overshooting cubic y = x^3-x*sin(x*pi)
function BackEaseIn(p: AHFloat) : AHFloat;
begin
	result := p * p * p - p * sin(p * M_PI);
end;

// Modeled after overshooting cubic y = 1-((1-x)^3-(1-x)*sin((1-x)*pi))
function BackEaseOut(p: AHFloat) : AHFloat;
var f : AHFloat;
begin
	f := (1 - p);
	result := 1 - (f * f * f - f * sin(f * M_PI));
end;

// Modeled after the piecewise overshooting cubic function:
// y = (1/2)*((2x)^3-(2x)*sin(2*x*pi))           ; [0, 0.5)
// y = (1/2)*(1-((1-x)^3-(1-x)*sin((1-x)*pi))+1) ; [0.5, 1]
function BackEaseInOut(p: AHFloat) : AHFloat;
var f : AHFloat;
begin
	if (p < 0.5) then
	begin
		f := 2 * p;
		result := 0.5 * (f * f * f - f * sin(f * M_PI));
	end
	else
	begin
		f := (1 - (2*p - 1));
		result := 0.5 * (1 - (f * f * f - f * sin(f * M_PI))) + 0.5;
        end;
end;

function BounceEaseIn(p: AHFloat) : AHFloat;
begin
	result := 1 - BounceEaseOut(1 - p);
end;

function BounceEaseOut(p: AHFloat) : AHFloat;
begin
	if (p < 4/11.0) then
		result := (121 * p * p)/16.0
	else if (p < 8/11.0) then
		result := (363/40.0 * p * p) - (99/10.0 * p) + 17/5.0
	else if (p < 9/10.0) then
		result := (4356/361.0 * p * p) - (35442/1805.0 * p) + 16061/1805.0
	else
		result := (54/5.0 * p * p) - (513/25.0 * p) + 268/25.0;
end;

function BounceEaseInOut(p: AHFloat) : AHFloat;
begin
	if (p < 0.5) then
		result := 0.5 * BounceEaseIn(p*2)
	else
		result := 0.5 * BounceEaseOut(p * 2 - 1) + 0.5;
end;


end.

