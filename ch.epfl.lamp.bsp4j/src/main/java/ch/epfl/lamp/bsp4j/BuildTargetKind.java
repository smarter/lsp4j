/*******************************************************************************
 * Copyright (c) 2016 TypeFox GmbH (http://www.typefox.io) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package ch.epfl.lamp.bsp4j;

public enum BuildTargetKind {
	
	Library(1),

  /** This target can be compiled and tested via
    * method buildTarget/test */	
	Test(2),

  /** This target can be tested via method
    * buildTarget/test and may run slower compared to a Test. */  
	IntegrationTest(3),

  /** This target can be run via method buildTarget/run */
	Main(4);
	
	private final int value;
	
	BuildTargetKind(int value) {
		this.value = value;
	}
	
	public int getValue() {
		return value;
	}
	
	public static BuildTargetKind forValue(int value) {
		BuildTargetKind[] allValues = BuildTargetKind.values();
		if (value < 1 || value > allValues.length)
			throw new IllegalArgumentException("Illegal enum value: " + value);
		return allValues[value - 1];
	}

}
