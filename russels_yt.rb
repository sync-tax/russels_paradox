use_debug false
use_bpm 160

#MIXER------------------------------------------------------------
main_volume = 1.0

kick_volume = 0.0
bass_volume = 0.075 * kick_volume

acid_noise_volume = 2.0
an_rate = 1.5
an_bs = 8
an_pitch = (ring 12, 14, 16)
an_atk = 2

mad_saw_volume = 0.0
ms_bs = 16

beep_volume = 0.0
sheet_drum_volume = 0.0
sword_volume = 0.0
#------------------------------------------------------------------

#RHYTMS------------------------------------------------------------
sheet_rhythm = (ring 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0,
                1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

beep_rhythm = (ring 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0,
               0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0)

kick_rhythm = (ring 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
               1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
               1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
               1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0)
#------------------------------------------------------------------

#COMPONENTS------------------------------------------------------------
with_fx :lpf, cutoff: 80 do
  with_fx :eq, amp: 3, low_shelf: -1, low: -0.4 do
    live_loop :kick do
      sample :bd_tek,
        amp: kick_volume * main_volume * kick_rhythm.tick,
        sustain_level: 0.25
      sleep 0.5
    end
  end
end


live_loop :bassline do
  sleep 0.5
  with_fx :distortion do
    with_fx :eq, amp: 4, low_shelf: -0.5, low: -0.25 do
      with_synth :fm do #dull bell & beep
        
        bass_notes1 = (ring :d1, :d2)
        bass_notes2 = (ring :c2, :d2)
        bass_notes3 = (ring :d2, :d2)
        
        play bass_notes2.tick,
          amp: bass_volume * main_volume,
          decay: 0.125,
          release: 0.3,
          sustain: 0.25,
          attack: 0.15,
          depth: 0.01,
          divisor: 2
      end
    end
  end
  sleep 0.5
end


live_loop :beep do
  with_fx :reverb, cutoff: 80 do
    sample :elec_blip,
      attack: 0.1,
      cutoff: rrand(80, 100),
      amp: beep_volume * beep_rhythm.tick * main_volume
  end
  sleep 0.5
end

with_fx :gverb do
  live_loop :sheet_drum do
    sample :drum_heavy_kick,
      amp: sheet_drum_volume * main_volume * sheet_rhythm.tick,
      rate: 2.75,
      beat_stretch: (ring 12, 14).tick,
      release: 0.05
    sleep 0.5
  end
end


live_loop :acid_noise do
  with_fx :wobble do
    sample :bd_zome,
      amp: acid_noise_volume * main_volume,
      rate: an_rate,
      beat_stretch: an_bs,
      pitch: an_pitch.tick,
      release: 0.5,
      attack: an_atk,
      cutoff: 100
    sleep 8
  end
end


with_fx :reverb do
  live_loop :mad_saw do
    sample :bd_zome,
      amp: mad_saw_volume  * main_volume,
      rate: -2,
      beat_stretch: ms_bs,
      pitch: (ring 10, 12, 10, 12).tick,
      release: 1,
      cutoff: 120
    sleep 8
  end
end


with_fx :reverb do
  live_loop :sword do
    sample :drum_cymbal_pedal,
      amp: sword_volume * main_volume,
      rate: -2,
      beat_stretch: (ring 0.001, 3).tick,
      pitch_stretch: 1.2,
      release: 0.1
    sleep 4
  end
end
