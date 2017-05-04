{-# LANGUAGE FlexibleInstances #-}
import Graphics.Gloss

--A 2-dimensional point
type Point2D = (Float, Float)

--A curve represented by a function from [0;1] -> Points in the plane
type Curve = Float -> Point2D

--An animated curve represented by a function from time in [0;1] to a curve
type Anim = Float -> Curve

--Input time in seconds and output is a function that oscillates between 0 and 1
oscilate :: Float -> Float
oscilate f = 0.5 + 0.5 * (sin f)

--Function that samples a curve into a list of 2D points.
sample :: Curve -> [Point2D]
sample curve = sampleHelper curve 0 []

sampleHelper :: Curve -> Float -> [Point2D] -> [Point2D]
sampleHelper curve cur acc = if cur > 1
                             then acc
                             else sampleHelper curve (cur + 0.01) ((curve cur) : acc)

--convert a curve to the format expected by Gloss
convCurve :: Curve -> Picture
convCurve curve = Line (sample curve)

--Convert an animation to the format expected by Gloss
convAnim :: Anim -> Float -> Picture
convAnim anim f = convCurve (anim (oscilate f))

--Function to show a graphics representation of a curve
showCurve :: Curve -> IO ()
showCurve curve = display (InWindow "Curve" (800, 600) (0, 0)) white (convCurve curve)

--Function to show a graphics representation of an animated curve
showAnim :: Anim -> IO ()
showAnim anim = animate (InWindow "Animation" (800, 600) (0, 0)) white (convAnim anim)

--Type class Interpolatable for things that can be interpolated
class Interpolatable a where
  interpolate :: a -> a -> Float -> a
  quadratic :: a -> a -> a -> Float -> a
  cubic :: a -> a -> a -> a -> Float -> a
  cubic p0 p1 p2 p3 f = interpolate (quadratic p0 p1 p2 f) (quadratic p1 p2 p3 f) f
  quadratic p0 p1 p2 f = interpolate (interpolate p0 p1 f) (interpolate p1 p2 f) f

instance Interpolatable Point2D where
  interpolate (x1, y1) (x2, y2) f = let invF = 1.0 - f in ((invF*x1 + f*x2), (invF*y1 + f*y2))

instance Interpolatable Curve where
  interpolate c1 c2 f x = interpolate (c1 x) (c2 x) f

instance Interpolatable Anim where
  interpolate a1 a2 f t = interpolate (a1 t) (a2 t) f

--Example curves to play with
exampleCurve1 :: Curve
exampleCurve1 f = let f1 = f*10 in ((cos f1) * f1 * 10, (sin f1) * f1 * 10)

exampleCurve2 :: Curve
exampleCurve2 f = let f1 = f*10 in ((cos (-f1)) * f1 * 10, (sin (-f1)) * f1 * 10)

animCurve :: Anim
animCurve t f = let f1 = f*40*t in ((cos f1) * f * 200, (sin f1) * f * 200)

--Bezier curves

bezier1 :: Curve
bezier1 = quadratic (-200,0) (0,400) (200, 0)

bezier2 :: Curve
bezier2 = quadratic (-200,0) (0,-400) (200, 0)

bezier3 :: Curve
bezier3 = cubic (-200,0) (-200,400) (200, -400) (200, 0)

anim1 :: Anim
anim1 = quadratic bezier1 bezier3 bezier2

main = showAnim anim1
