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

@JsonSegment("workspace")
public interface WorkspaceService {
  /**
   * The workspace build targets request is sent from the client to the server
   * to ask for the list of all available build targets in the workspace.
   */
  @JsonRequest
  CompletableFuture<WorkspaceBuildTargetsResult> buildTargets(WorkspaceBuildTargetsParams params);
}
