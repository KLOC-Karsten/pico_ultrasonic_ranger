with HAL.GPIO;

generic
   GPIO   : not null HAL.GPIO.Any_GPIO_Point;
package Pico_Ultrasonic_Ranger is

   --  Measure the distance.
   procedure Measure (Millimeters : out Natural;
                      Success     : out Boolean;
                      Timeout     : Natural := 10_000);

end Pico_Ultrasonic_Ranger;
