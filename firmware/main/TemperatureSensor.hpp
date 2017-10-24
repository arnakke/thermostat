/*
 * TemperatureSensor.hpp - Thermistor based temperature sensor class
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

#ifndef TEMPERATURESENSOR_HPP_
#define TEMPERATURESENSOR_HPP_

#include "ADC.hpp"

/**
 * Read temperature from the sensor using ADC conversion of thermistor voltage.
 */
class TemperatureSensor {
public:
	TemperatureSensor(ADC&& thermistor_channel, ADC&& reference_channel);

	/**
	 * Read the current temperature
	 * @return The temperature in degrees Celsius
	 */
	float read();

private:
	// Samples to average
	static const int samples = 100;
	// Upper resistor in voltage divider
	static const int R_upper = 6800;
	// Parameters for thermistor AVX ND03M00472JCC
	static const int Rntc25 = 4700;
	static const int Bntc = 3950;

	ADC thermistor;
	ADC reference;
};

#endif /* TEMPERATURESENSOR_HPP_ */
