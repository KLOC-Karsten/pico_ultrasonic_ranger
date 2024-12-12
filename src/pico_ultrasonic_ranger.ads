--
--  Copyright 2024 (C) Karsten Lueth
--
--  SPDX-License-Identifier: BSD-3-Clause
--

with HAL.GPIO;

generic
   GPIO   : not null HAL.GPIO.Any_GPIO_Point;
package Pico_Ultrasonic_Ranger is

   --  Measure and return the distance in millimeters.
   --  Measuring is aborted after Timeout milliseconds.
   procedure Measure (Millimeters : out Natural;
                      Success     : out Boolean;
                      Timeout     : Natural := 10_000);

end Pico_Ultrasonic_Ranger;
