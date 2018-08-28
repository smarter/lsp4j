/*******************************************************************************
 * Copyright (c) 2016 TypeFox GmbH (http://www.typefox.io) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package ch.epfl.lamp.bsp4j.services;

import java.util.Collections;
import java.util.List;
import java.util.concurrent.CompletableFuture;

import ch.epfl.lamp.bsp4j.MessageActionItem;
import ch.epfl.lamp.bsp4j.MessageParams;
import ch.epfl.lamp.bsp4j.PublishDiagnosticsParams;
import ch.epfl.lamp.bsp4j.RegistrationParams;
import ch.epfl.lamp.bsp4j.ShowMessageRequestParams;
import ch.epfl.lamp.bsp4j.UnregistrationParams;
import org.eclipse.lsp4j.jsonrpc.services.JsonNotification;
import org.eclipse.lsp4j.jsonrpc.services.JsonRequest;

import com.google.common.annotations.Beta;

public interface BuildClient {
	/**
	 * The client/registerCapability request is sent from the server to the client
	 * to register for a new capability on the client side.
	 * Not all clients need to support dynamic capability registration.
	 * A client opts in via the ClientCapabilities.dynamicRegistration property
	 */
	@JsonRequest("client/registerCapability")
	default CompletableFuture<Void> registerCapability(RegistrationParams params) {
		throw new UnsupportedOperationException();
	}

	/**
	 * The client/unregisterCapability request is sent from the server to the client
	 * to unregister a previously register capability.
	 */
	@JsonRequest("client/unregisterCapability")
	default CompletableFuture<Void> unregisterCapability(UnregistrationParams params) {
		throw new UnsupportedOperationException();
	}

	/**
	 * The telemetry notification is sent from the server to the client to ask
	 * the client to log a telemetry event.
	 */
	@JsonNotification("telemetry/event")
	void telemetryEvent(Object object);

	/**
	 * Diagnostics notifications are sent from the server to the client to
	 * signal results of validation runs.
	 */
	@JsonNotification("build/publishDiagnostics")
	void publishDiagnostics(PublishDiagnosticsParams diagnostics);

	/**
	 * The show message notification is sent from a server to a client to ask
	 * the client to display a particular message in the user interface.
	 */
	@JsonNotification("build/showMessage")
	void showMessage(MessageParams messageParams);

	/**
	 * The log message notification is send from the server to the client to ask
	 * the client to log a particular message.
	 */
	@JsonNotification("build/logMessage")
	void logMessage(MessageParams message);
}
