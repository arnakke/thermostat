/*
 * ADC.hpp - ESP32 ADC class
 *
 * Copyright 2017 Marcel Clausen
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#ifndef ADC_HPP_
#define ADC_HPP_

#include "driver/adc.h"

/**
 * Read calibrated values from the ESP32 adc1.
 * Internal attenuation is not supported since it causes additional
 * non-linearity.
 */
class ADC
{
public:
	/// Offset voltage of the 0 reading in volts (adjust as part of calibration)
	static float offset;

	/// Voltage of the internal reference (voltage that gives raw reading
	/// of 4095) (adjust as part of calibration)
	static float vref;

	/**
	 * Create a new instance tied to channel.
	 * @param channel The channel to use in the instance
	 */
	ADC(adc1_channel_t channel);

	/**
	 * Read the raw, uncalibrated, conversion value
	 * @return A number between 0 and 4095
	 */
	int read_raw();

	/**
	 * Read the calibrated voltage at the ADC channel
	 * @return The voltage in volts
	 */
	float read_voltage();

	/**
	 * Average a number of voltage samples
	 * @param n The number of samples to read
	 * @return The average reading
	 */
	float read_voltage_avg(int n);

private:
	adc1_channel_t channel;

	float to_voltage(int raw);
};

#endif /* ADC_HPP_ */
