/*******************************************************************************
 * Copyright (c) 2016 TypeFox GmbH (http://www.typefox.io) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package ch.epfl.lamp.bsp4j;

public enum ScalaPlatformKind {

	JVM(1),
	JS(2),
	Native(3);

	private final int value;

	ScalaPlatformKind(int value) {
		this.value = value;
	}

	public int getValue() {
		return value;
	}

	public static ScalaPlatformKind forValue(int value) {
		ScalaPlatformKind[] allValues = ScalaPlatformKind.values();
		if (value < 1 || value > allValues.length)
			throw new IllegalArgumentException("Illegal enum value: " + value);
		return allValues[value - 1];
	}

}
