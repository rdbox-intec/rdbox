import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { BootstrapComponent } from './bootstrap/bootstrap.component';
import { VerificationGuard } from './guard/verification.guard';


const routes: Routes = [
  {path: 'bootstrap', component: BootstrapComponent, canActivate: [VerificationGuard]},
  {path: '', component: LoginComponent},
  {path: '**', redirectTo: ''}
];

@NgModule({
  imports: [RouterModule.forRoot(routes, {useHash:true})],
  exports: [RouterModule]
})
export class AppRoutingModule { }
