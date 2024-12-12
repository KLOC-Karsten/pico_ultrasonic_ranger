--
--  Copyright 2024 (C) Karsten Lueth
--
--  SPDX-License-Identifier: BSD-3-Clause
--
--  Tested with: https://github.com/Seeed-Studio/Seeed_Arduino_UltrasonicRanger
--  Wiki: https://wiki.seeedstudio.com/Grove-Ultrasonic_Ranger/

with HAL;
with RP.Timer; use RP.Timer;
with RP.Device; use RP.Device;

package body Pico_Ultrasonic_Ranger is

   --  Measure the duration of the pulse in the given GPIO.
   --  Returns the duration in microseconds.
   procedure Pulse_In (T       : out Time;
                       Success : out Boolean;
                       Timeout : Time)
   is
      Start_Time, Start_Pulse : Time;

   begin
      T := 0;
      Success := False;
      Start_Time := Clock;

      --  Wait for previous pulse to end.
      while GPIO.Set loop
         if (Clock - Start_Time) > Timeout then
            return;
         end if;
      end loop;

      --  Wait for the pulse to start.
      while not GPIO.Set loop
         if (Clock - Start_Time) > Timeout then
            return;
         end if;
      end loop;

      Start_Pulse := Clock;

      --  Wait for the pulse to stop.
      while GPIO.Set loop
         if (Clock - Start_Time) > Timeout then
            return;
         end if;
      end loop;

      Success := True;
      T := Clock - Start_Pulse;

   end Pulse_In;

   --  Creates the starting pulse for the sensor and then measures
   --  the duration of in input pulse.
   procedure Duration (T       : out Time;
                       Success : out Boolean;
                       Timeout : Time) is
   begin
      GPIO.Set_Mode (HAL.GPIO.Output);
      GPIO.Clear;
      Timer.Delay_Microseconds (2);
      GPIO.Set;
      Timer.Delay_Microseconds (5);
      GPIO.Clear;
      GPIO.Set_Pull_Resistor (HAL.GPIO.Pull_Up);
      GPIO.Set_Mode (HAL.GPIO.Input);

      Pulse_In (T, Success, Timeout);
   end Duration;

   --  Measure the distance.
   procedure Measure (Millimeters : out Natural;
                      Success     : out Boolean;
                      Timeout     : Natural := 10_000)
   is
      T : Time;
   begin
      Duration (T, Success, Milliseconds (Timeout));
      if Success then
         Millimeters := Natural (T) * 5 / 29;
      end if;
   end Measure;

end Pico_Ultrasonic_Ranger;
