/**
 * Copyright (c) 2016 TypeFox GmbH (http://www.typefox.io) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package ch.epfl.lamp.bsp4j.services;

import java.util.concurrent.CompletableFuture;

import ch.epfl.lamp.bsp4j.InitializeBuildParams;
import ch.epfl.lamp.bsp4j.InitializeBuildResult;
import ch.epfl.lamp.bsp4j.InitializedBuildParams;
import org.eclipse.lsp4j.jsonrpc.services.JsonDelegate;
import org.eclipse.lsp4j.jsonrpc.services.JsonNotification;
import org.eclipse.lsp4j.jsonrpc.services.JsonRequest;
import org.eclipse.lsp4j.jsonrpc.services.JsonSegment;

@JsonSegment("build")
public interface LanguageServer {
	/**
	 * The initialize request is sent as the first request from the client to
	 * the server.
	 * 
	 * If the server receives request or notification before the initialize request it should act as follows:
	 * 	- for a request the respond should be errored with code: -32001. The message can be picked by the server.
	 *  - notifications should be dropped, except for the exit notification. This will allow the exit a server without an initialize request.
	 *  
	 * Until the server has responded to the initialize request with an InitializeResult 
	 * the client must not sent any additional requests or notifications to the server.
	 * 
	 * During the initialize request the server is allowed to sent the notifications window/showMessage, 
	 * window/logMessage and telemetry/event as well as the window/showMessageRequest request to the client.
	 */
	@JsonRequest
	CompletableFuture<InitializeBuildResult> initialize(InitializeBuildParams params);

	/**
	 * The initialized notification is sent from the client to the server after
	 * the client received the result of the initialize request but before the
	 * client is sending any other request or notification to the server. The
	 * server can use the initialized notification for example to dynamically
	 * register capabilities.
	 */
	@JsonNotification
	default void initialized(InitializedBuildParams params) {
	}

	/**
	 * The shutdown request is sent from the client to the server. It asks the
	 * server to shutdown, but to not exit (otherwise the response might not be
	 * delivered correctly to the client). There is a separate exit notification
	 * that asks the server to exit.
	 */
	@JsonRequest(useSegment = false)
	CompletableFuture<Object> shutdown();

	/**
	 * A notification to ask the server to exit its process.
	 */
	@JsonNotification(useSegment = false)
	void exit();

	/**
	 * Provides access to the textDocument services.
	 */
	@JsonDelegate
	TextDocumentService getTextDocumentService();

	/**
	 * Provides access to the workspace services.
	 */
	@JsonDelegate
	WorkspaceService getWorkspaceService();
	
}
