with RP.Device;
with RP.Clock;
with RP.GPIO;
with Pico;
with RP.Timer.Interrupts;
with Pico_Ultrasonic_Ranger;

procedure Ranger is
   package Ranger is new Pico_Ultrasonic_Ranger (GPIO => Pico.GP16'Access);
   Success : Boolean := False;
   Distance : Natural := 0;
begin

   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.Clock.Enable (RP.Clock.PERI);
   RP.Device.Timer.Enable;

   Pico.LED.Configure (RP.GPIO.Output);
   Pico.LED.Clear;
   loop
      --  Measure the distance.
      Ranger.Measure (Distance, Success);

      if Success then
         if Distance < 300 then
            Pico.LED.Set;
         else
            Pico.LED.Clear;
         end if;
      end if;
      RP.Device.Timer.Delay_Milliseconds (300);
   end loop;

end Ranger;
