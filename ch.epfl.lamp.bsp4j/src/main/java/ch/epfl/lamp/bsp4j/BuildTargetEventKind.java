/*******************************************************************************
 * Copyright (c) 2016 TypeFox GmbH (http://www.typefox.io) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package ch.epfl.lamp.bsp4j;

public enum BuildTargetEventKind {
	
	Created(1),
	Changed(2),
	Deleted(3);

  private final int value;
	
	BuildTargetEventKind(int value) {
		this.value = value;
	}
	
	public int getValue() {
		return value;
	}
	
	public static BuildTargetEventKind forValue(int value) {
		BuildTargetEventKind[] allValues = BuildTargetEventKind.values();
		if (value < 1 || value > allValues.length)
			throw new IllegalArgumentException("Illegal enum value: " + value);
		return allValues[value - 1];
	}

}