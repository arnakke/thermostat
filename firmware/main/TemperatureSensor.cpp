/*
 * TemperatureSensor.cpp - Thermistor based temperature sensor class
 * implementation
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

#include "TemperatureSensor.hpp"
#include <math.h>


TemperatureSensor::TemperatureSensor(ADC&& thermistor_channel,
		ADC&& reference_channel) :
		thermistor(thermistor_channel),
		reference(reference_channel)
{
}


float TemperatureSensor::read()
{
	float ref_voltage = 2 * reference.read_voltage_avg(samples);
	float fraction = thermistor.read_voltage_avg(samples) / ref_voltage;
	float Rntc = fraction * R_upper / (1.0f - fraction);

	// Temperature from B-parameter equation
	float kelvin = 1.0f / (1.0f / 298.15f + log(Rntc / Rntc25) / Bntc);

	// Return celsius
	return kelvin - 273.15f;
}
