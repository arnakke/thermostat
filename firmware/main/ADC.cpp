/*
 * ADC.cpp - ESP32 ADC class implementation
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

#include "ADC.hpp"


// Static data members
float ADC::offset = 0.09;
float ADC::vref = 1.1;


ADC::ADC(adc1_channel_t channel) :
	channel(channel)
{
	adc1_config_width(ADC_WIDTH_12Bit);
	adc1_config_channel_atten(channel, ADC_ATTEN_0db);
}


int ADC::read_raw()
{
	return adc1_get_raw(channel);
}


float ADC::read_voltage()
{
	return to_voltage(read_raw());
}


float ADC::read_voltage_avg(int n)
{
	int result = 0;
	for (int i = 0; i < n; i++) {
		result += read_raw();
	}
	return to_voltage(result / n);
}


float ADC::to_voltage(int raw)
{
	return raw / 4096.0f * (vref - offset) + offset;
}
