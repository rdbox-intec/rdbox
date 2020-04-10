import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule }   from '@angular/forms';
import { RouterModule } from '@angular/router';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { MatDialogModule } from '@angular/material/dialog';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field'
import { MatInputModule } from '@angular/material/input';
import { MatCardModule } from '@angular/material/card';
import { MatSelectModule } from '@angular/material/select';
import { MatRadioModule } from '@angular/material/radio';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatIconModule } from '@angular/material/icon';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { VerificationResultDialogComponent } from './verification-result-dialog/verification-result-dialog.component';
import { BootstrapComponent } from './bootstrap/bootstrap.component';
import { LoginComponent } from './login/login.component';
import { AutofocusDirective } from './autofocus.directive';
import { DeployStateDialogComponent } from './deploy-state-dialog/deploy-state-dialog.component';
import { EmptyDialogComponent } from './empty-dialog/empty-dialog.component';

@NgModule({
  declarations: [
    AppComponent,
    VerificationResultDialogComponent,
    BootstrapComponent,
    LoginComponent,
    AutofocusDirective,
    DeployStateDialogComponent,
    EmptyDialogComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    BrowserAnimationsModule,
    RouterModule,
    ReactiveFormsModule,
    MatToolbarModule,
    MatDialogModule,
    MatButtonModule,
    MatFormFieldModule,
    MatInputModule,
    MatCardModule,
    MatSelectModule,
    MatRadioModule,
    MatAutocompleteModule,
    MatProgressBarModule,
    MatProgressSpinnerModule,
    MatIconModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
