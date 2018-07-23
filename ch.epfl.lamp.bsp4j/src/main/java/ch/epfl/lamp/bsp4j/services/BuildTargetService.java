/**
 * Copyright (c) 2016 TypeFox GmbH (http://www.typefox.io) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package ch.epfl.lamp.bsp4j.services;

import java.util.List;
import java.util.concurrent.CompletableFuture;

import ch.epfl.lamp.bsp4j.*;
import org.eclipse.lsp4j.jsonrpc.services.JsonNotification;
import org.eclipse.lsp4j.jsonrpc.services.JsonRequest;
import org.eclipse.lsp4j.jsonrpc.services.JsonSegment;

import com.google.common.annotations.Beta;

@JsonSegment("buildTarget")
public interface BuildTargetService {
	/**
   * The build target changed notification is sent from the server to the client
   * to signal a change in a build target. The server communicates during the
   * initialize handshake whether this method is supported or not.
	 */
	@JsonNotification
	void didChange(DidChangeBuildTargetParams params);

  @JsonRequest
  CompletableFuture<CompileReport> compile(CompileParams params);
}
