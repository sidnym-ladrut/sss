::  |%
::  ++  name  %sum
::  +$  rock  [%0 @]
::  +$  vock
::    $%  rock
::    ==
::  +$  wave  [%0 @]
::  +$  vave
::    $%  wave
::    ==
::  ++  urck  |=(voc=vock `rock`voc)
::  ++  uwve  |=(vav=vave `wave`vav)
::  ++  wash  |=([roc=rock wav=wave] `rock`[%0 (add +.roc +.wav)])
::  --
|%
++  name  %sum
+$  rock  [%1 @]
+$  vock
  $%  [%0 @]
      rock
  ==
+$  wave  [%1 @]
+$  vave
  $%  [%0 @]
      wave
  ==
++  urck
  |=  voc=vock
  ^-  rock
  ?-  -.voc
    %0  [%1 +.voc]
    %1  voc
  ==
++  uwve
  |=  vav=vave
  ^-  wave
  ?-  -.vav
    %0  [%1 +.vav]
    %1  vav
  ==
++  wash
  |=  [roc=rock wav=wave]
  ^-  rock
  [%1 (add +.roc +.wav)]
--
